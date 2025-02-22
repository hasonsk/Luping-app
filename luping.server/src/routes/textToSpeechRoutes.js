import { Router } from "express";
import { body } from "express-validator";
import validate from "../middlewares/validate.js";
// import authenticate from "../middlewares/authenticate.js";
import { synthesizeText } from "../controllers/textToSpeechController.js";

const router = Router();

/**
 * @swagger
 * /text-to-speech:
 *   post:
 *     summary: Synthesize text to speech
 *     tags: [TextToSpeech]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - text
 *             properties:
 *               text:
 *                 type: string
 *                 description: The text to synthesize
 *             example:
 *               text: "你好，世界！"
 *     responses:
 *       200:
 *         description: Successfully synthesized text to speech
 *         content:
 *           audio/wav:
 *             schema:
 *               type: string
 *               format: binary
 *       400:
 *         description: Bad request (e.g., missing text)
 *       500:
 *         description: Internal server error
 */
router.post(
  "/",
  // authenticate,
  [
    body("text")
      .isString()
      .withMessage("Text must be a string")
      .notEmpty()
      .withMessage("Text is required"),
  ],
  validate,
  synthesizeText,
);

export default router;
