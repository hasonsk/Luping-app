import { GoogleGenerativeAI } from "@google/generative-ai";
import * as fs from 'fs/promises';
import { GEMINI_API_KEY } from '../configs/config.js';
import logger from '../configs/logger.js';

const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);
const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash-002" });

const generationConfig = {
    temperature: 0.9,
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
            const result = await chat.sendMessage(prompt);
            let responseText = result.response.text();
            responseText = responseText.replace(/```json\n?|\n?```/g, '').trim();
            logger.info(`Chatbot API Response (Attempt ${4 - retries}): ${responseText}`);

            let parsedResponse;
            try {
                parsedResponse = JSON.parse(responseText);
            } catch (parseError) {
               logger.error(`Error parsing chatbot response: ${parseError.message}, retrying...`);
                retries--;
                await new Promise(resolve => setTimeout(resolve, delay));
                delay *= 1.5; // Increase delay for next retry
                continue;
            }

            if (validateChatbotResponse(parsedResponse)) {
                return parsedResponse;
            } else {
                logger.warn(`Chatbot response failed validation, retrying...`);
                retries--;
                await new Promise(resolve => setTimeout(resolve, delay));
                 delay *= 1.5; // Increase delay for next retry
            }
        } catch (error) {
            logger.error(`Chatbot API Error: ${error.message}, retries remaining: ${retries}`);
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