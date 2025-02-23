import { GoogleGenerativeAI, HarmCategory, HarmBlockThreshold } from "@google/generative-ai";
import * as fs from "fs/promises";
import { GEMINI_API_KEY } from "../configs/config.js";
import logger from "../configs/logger.js";
import { createLogger, transports, format } from "winston";
import path from "path";

// Create a separate logger for chatbot-specific logs
const chatbotLogger = createLogger({
  level: "info",
  format: format.combine(
    format.timestamp({ format: "YYYY-MM-DD HH:mm:ss" }),
    format.json(),
  ),
  transports: [
    new transports.File({
      filename: path.join("logs", "chatbot.log"),
      level: "info",
    }),
  ],
});

const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);
const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash-002" });

const generationConfig = {
  temperature: 1.2,
  topP: 1,
  topK: 36,
  maxOutputTokens: 1000,
};

const validateChatbotResponse = (response) => {
  return (
    response &&
    response.response &&
    typeof response.response.sentence === "string" &&
    typeof response.response.pinyin === "string" &&
    typeof response.response.meaning_VN === "string" &&
    response.hasOwnProperty('comment') &&
    typeof response.comment === "string" &&
    response.suggested_sentences &&
    Array.isArray(response.suggested_sentences) &&
    response.suggested_sentences.length <= 2 &&
    response.suggested_sentences.every(
      (s) =>
        s &&
        typeof s.sentence === "string" &&
        typeof s.pinyin === "string" &&
        typeof s.meaning_VN === "string",
    )
  );
};

const generateChatbotResponse = async (userInput) => {
  const promptTemplate = await fs.readFile(
    "./src/services/prompt.xml",
    "utf-8",
  );

  // Basic input validation (prevent prompt injection),  handle null/undefined
  const safeRole = userInput?.role ? userInput.role : "Any role";
  const safeTopic = userInput?.topic ? userInput.topic : "Any topic";
  const safeChineseLevel = userInput?.chinese_level || "HSK 1"; //  default value
  const safeUserMessage = userInput?.user_message || ""; //  default value
  const safeChatHistory = userInput?.chat_history || ""; // default value

  logger.info({ safeRole, safeTopic, safeChineseLevel, safeUserMessage, safeChatHistory });

  const prompt = promptTemplate
    .replace("{{$role}}", safeRole)
    .replace("{{$topic}}", safeTopic)
    .replace("{{$chinese_level}}", safeChineseLevel)
    .replace("{{$user_message}}", safeUserMessage)
    .replace("{{$chat_history}}", safeChatHistory);

  const chat = model.startChat({
    generationConfig,
    history: [], // History is handled in the prompt
  });

  let retries = 3;
  let delay = 100; // Initial delay in milliseconds
  let lastError; // Store the last error for the final error throw

  while (retries > 0) {
    const attempt = 4 - retries; // Calculate the current attempt number
    try {
      const startTime = Date.now();

      // Count prompt tokens *before* sending the message
      const promptTokenCount = await model.countTokens(prompt).totalTokens;
      // chatbotLogger.info({ attempt, type: 'prompt_tokens', tokens: promptTokenCount.totalTokens });

      const result = await chat.sendMessage(prompt);
      const endTime = Date.now();
      const latency = endTime - startTime;
      let responseText = result.response.text();

      // Count response tokens *after* receiving the response
      const responseTokenCount =
        await model.countTokens(responseText).totalTokens;
      // chatbotLogger.info({ attempt, type: 'response_tokens', tokens: responseTokenCount.totalTokens });

      responseText = responseText.replace(/```json\n?|\n?```/g, "").trim();
      // Log raw response and timing
      chatbotLogger.info({
        attempt,
        promptTokenCount,
        responseTokenCount,
        latency: `${latency}ms`,
        userInput,
        rawResponse: responseText,
      });

      let parsedResponse;
      try {
        parsedResponse = JSON.parse(responseText);
      } catch (parseError) {
        // Log the parsing error
        chatbotLogger.warn({
          attempt,
          error: `Parsing error: ${parseError.message}`,
          rawResponse: responseText,
        });
        lastError = parseError;
        logger.error(parseError.message);
        throw parseError; // Re-throw to be caught in the outer catch block
      }

      if (validateChatbotResponse(parsedResponse)) {
        // Log successful response and token usage
        chatbotLogger.info({
          attempt,
          status: "success",
          parsedResponse,
          promptFeedback:
            result.response.promptFeedback || "No feedback provided", // Handle missing feedback
        });
        return parsedResponse;
      } else {
        const validationError = new Error("Response validation failed");
        chatbotLogger.warn({
          attempt,
          status: "failed validation",
          parsedResponse,
        });
        lastError = validationError;
        logger.error(validationError.message);
        throw validationError; // Throw a validation error
      }
    } catch (error) {
      // Generic error handling (API errors, network issues, etc.)
      chatbotLogger.error({
        attempt,
        error: error.message,
        stack: error.stack, // Log the full stack trace
      });
      lastError = error; // Store the error

      retries--;
      if (retries === 0) {
        const err = new Error("Chatbot service failed.");
        err.status = 500;
        err.detail =
          "The chatbot service is currently unavailable after multiple retries. Last error: " +
          lastError.message;
        logger.error(err.detail);
        throw err;
      }
      await new Promise((resolve) => setTimeout(resolve, delay));
      delay *= 1.5; // Exponential backoff
    }
  }
};

export { generateChatbotResponse };
