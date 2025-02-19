import * as chatBotService from "../services/chatBotService.js";

const getChatbotResponse = async (req, res, next) => {
  try {
    const userInput = req.body;
    const chatbotResponse =
      await chatBotService.generateChatbotResponse(userInput);
    res.status(200).json(chatbotResponse);
  } catch (error) {
    next(error);
  }
};

export { getChatbotResponse };
