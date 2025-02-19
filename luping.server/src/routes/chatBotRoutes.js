import { Router } from "express";
import { body } from "express-validator";
import validate from "../middlewares/validate.js";
import authenticate from "../middlewares/authenticate.js";
import { getChatbotResponse } from "../controllers/chatBotController.js";

const router = Router();

/**
 * @swagger
 * tags:
 *   name: Chatbot
 *   description: API for chatbot interactions
 */

/**
 * @swagger
 * components:
 *   schemas:
 *     ChatbotRequest:
 *       type: object
 *       required:
 *         - role
 *         - topic
 *         - chinese_level
 *         - user_message
 *         - chat_history
 *       properties:
 *         role:
 *           type: string
 *           description: The role description of the chatbot (e.g., teacher's characteristics, background)
 *         topic:
 *           type: string
 *           description: The conversation topic
 *         chinese_level:
 *           type: string
 *           description: User's Chinese proficiency level (e.g., HSK 1)
 *         user_message:
 *           type: string
 *           description: The message from the user
 *         chat_history:
 *           type: array
 *           description: Previous messages in the conversation
 *           items:
 *             type: object
 *       example:
 *         role: "Cô giáo Hà - Giáo viên tiếng Trung sơ cấp, nữ, người Việt Nam, 25 tuổi, kiên nhẫn, nhẹ nhàng, khuyến khích học sinh."
 *         topic: "Chào hỏi và giới thiệu bản thân."
 *         chinese_level: "HSK 1"
 *         user_message: ""
 *         chat_history: []
 *
 *     ChatbotResponse:
 *       type: object
 *       properties:
 *         response:
 *           type: object
 *           description:  Response sentence with details
 *           properties:
 *             sentence:
 *               type: string
 *               description: Chinese sentence
 *             pinyin:
 *               type: string
 *               description: Pinyin pronunciation
 *             meaning_VN:
 *               type: string
 *               description: Vietnamese translation
 *         comment:
 *           type: string
 *           description: Additional comments or instructions
 *         suggested_sentences:
 *           type: array
 *           description: Suggested follow-up sentences
 *           items:
 *             type: object
 *             properties:
 *               sentence:
 *                 type: string
 *                 description: Chinese sentence
 *               pinyin:
 *                 type: string
 *                 description: Pinyin pronunciation
 *               meaning_VN:
 *                 type: string
 *                 description: Vietnamese translation
 *       example:
 *         response:
 *           sentence: "你好吗？"
 *           pinyin: "Nǐ hǎo ma?"
 *           meaning_VN: "Bạn khỏe không?"
 *         comment: ""
 *         suggested_sentences:
 *           - sentence: "我很好，谢谢！"
 *             pinyin: "Wǒ hěn hǎo, xiè xie!"
 *             meaning_VN: "Tôi rất tốt, cảm ơn!"
 *           - sentence: "我不错，谢谢！"
 *             pinyin: "Wǒ bù cuò, xiè xie!"
 *             meaning_VN: "Tôi ổn, cảm ơn!"
 */

/**
 * @swagger
 * /chatbot/response:
 *   post:
 *     summary: Get a response from the chatbot
 *     tags: [Chatbot]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/ChatbotRequest'
 *     responses:
 *       200:
 *         description: Successfully received chatbot response
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ChatbotResponse'
 *       400:
 *         description: Bad request
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.post(
  "/response",
  // authenticate,
  [
    body("role")
      .isString()
      .withMessage("Role must be a string")
      .notEmpty()
      .withMessage("Role is required"),
    body("topic")
      .isString()
      .withMessage("Topic must be a string")
      .notEmpty()
      .withMessage("Topic is required"),
    body("chinese_level")
      .isString()
      .withMessage("Chinese level must be a string")
      .notEmpty()
      .withMessage("Chinese level is required"),
    body("user_message")
      .isString()
      .withMessage("User message must be a string"),
    body("chat_history").isArray().withMessage("Chat history must be an array"),
  ],
  validate,
  getChatbotResponse,
);

export default router;
