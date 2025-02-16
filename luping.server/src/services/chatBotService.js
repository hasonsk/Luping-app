import { GoogleGenerativeAI } from "@google/generative-ai";
import * as fs from 'fs/promises';
import { GEMINI_API_KEY } from '../configs/config.js';
import logger from '../configs/logger.js';
import { createLogger, transports, format } from 'winston';
import path from 'path';

// Create a separate logger for chatbot-specific logs
const chatbotLogger = createLogger({
    level: 'info',
    format: format.combine(
        format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
        format.json()
    ),
    transports: [
        new transports.File({ filename: path.join('logs', 'chatbot.log'), level: 'info' })
    ]
});

const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);
const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash-002" });

const generationConfig = {
    temperature: 1.2,
    topP: 1,
    topK: 32,
    maxOutputTokens: 1000,
};

const validateChatbotResponse = (response) => {
    return (
        response &&
        Array.isArray(response.response_sentences) &&
        response.response_sentences.every(s => typeof s.sentence === 'string' && typeof s.pinyin === 'string' && typeof s.meaning_VN === 'string') &&
        typeof response.comment === 'string' &&
        Array.isArray(response.suggested_sentences) &&
        response.suggested_sentences.length <= 2 && // Based on the example, max 2 suggestions
        response.suggested_sentences.every(s => typeof s.sentence === 'string' && typeof s.pinyin === 'string' && typeof s.meaning_VN === 'string')
    );
};

const generateChatbotResponse = async (userInput) => {
    const promptTemplate = await fs.readFile('./src/services/prompt.xml', 'utf-8');

    // Basic input validation (prevent prompt injection)
    const safeRole = /^[a-zA-Z0-9\s]+$/.test(userInput.role) ? userInput.role : 'Any role';
    const safeTopic = /^[a-zA-Z0-9\s]+$/.test(userInput.topic) ? userInput.topic : 'Any topic';

    const prompt = promptTemplate
        .replace('{{$role}}', safeRole)
        .replace('{{$topic}}', safeTopic)
        .replace('{{$chinese_level}}', userInput.chinese_level)
        .replace('{{$user_message}}', userInput.user_message)
        .replace('{{$chat_history}}', userInput.chat_history);

    const chat = model.startChat({
        generationConfig,
        history: [], // History is handled in the prompt, not here
    });

    let retries = 3;
    let delay = 100; // Initial delay in milliseconds
    while (retries > 0) {
        try {
            const startTime = Date.now();
            // Count prompt tokens *before* sending the message
            const promptTokenCount = await model.countTokens(prompt);
            logger.info(`Prompt token count: ${promptTokenCount.totalTokens}`);
            chatbotLogger.info({
                type: 'prompt_tokens',
                tokens: promptTokenCount.totalTokens
            });

            const result = await chat.sendMessage(prompt);
            const endTime = Date.now();
            let responseText = result.response.text();

            // Count response tokens *after* receiving the response
            const responseTokenCount = await model.countTokens(responseText);
            logger.info(`Response token count: ${responseTokenCount.totalTokens}`);
             chatbotLogger.info({
                type: 'response_tokens',
                tokens: responseTokenCount.totalTokens
            });

            responseText = responseText.replace(/```json\n?|\n?```/g, '').trim();

            // Log the raw response and timing
            logger.info(`Chatbot API Response (Attempt ${4 - retries}): ${responseText}`);
            chatbotLogger.info({
                attempt: 4 - retries,
                latency: `${endTime - startTime}ms`,
                userInput: userInput,
                rawResponse: responseText,
            });

            let parsedResponse;
            try {
                parsedResponse = JSON.parse(responseText);
            } catch (parseError) {
                logger.error(`Error parsing chatbot response: ${parseError.message}, retrying...`);
                chatbotLogger.error({
                  attempt: 4 - retries,
                  error: `Parsing error: ${parseError.message}`,
                  rawResponse: responseText,
                });
                retries--;
                await new Promise(resolve => setTimeout(resolve, delay));
                delay *= 1.5; // Increase delay for next retry
                continue;
            }

            if (validateChatbotResponse(parsedResponse)) {
                 // Log successful response and token usage (if available)
                if (result.response.promptFeedback) {
                    chatbotLogger.info({
                        attempt: 4 - retries,
                        status: 'success',
                        parsedResponse: parsedResponse,
                        promptFeedback: result.response.promptFeedback,
                    });
                } else {
                  chatbotLogger.info({
                      attempt: 4 - retries,
                      status: "success",
                      parsedResponse: parsedResponse,
                  });
                }
                return parsedResponse;
            } else {
                logger.warn(`Chatbot response failed validation, retrying...`);
                chatbotLogger.warn({
                    attempt: 4 - retries,
                    status: 'failed validation',
                    parsedResponse: parsedResponse,
                });
                retries--;
                await new Promise(resolve => setTimeout(resolve, delay));
                 delay *= 1.5; // Increase delay for next retry
            }
        } catch (error) {
            logger.error(`Chatbot API Error: ${error.message}, retries remaining: ${retries}`);
            chatbotLogger.error({
              attempt: 4 - retries,
              error: error.message,
              stack: error.stack,
            });
            retries--;
            if(retries === 0){
              const err = new Error('Chatbot service failed.');
              err.status = 500;
              err.detail = "The chatbot service is currently unavailable after multiple retries. " + error.message;
              throw err;
            }
            await new Promise(resolve => setTimeout(resolve, delay));
             delay *= 1.5; // Increase delay for next retry
        }
    }
    const err = new Error('Chatbot service failed.');
    err.status = 500;
    err.detail = "The chatbot service is currently unavailable after multiple retries.";
    throw err;
};

export { generateChatbotResponse };