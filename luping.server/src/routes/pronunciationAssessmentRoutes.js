import { Router } from "express";
import multer from "multer";
import { assessPronunciation } from "../controllers/pronunciationAssessmentController.js";
import authenticate from "../middlewares/authenticate.js";

const router = Router();
const upload = multer({ dest: "uploads/" });

/**
 * @swagger
 * tags:
 *   name: PronunciationAssessment
 *   description: API for assessing pronunciation accuracy and providing feedback
 */

/**
 * @swagger
 * /pronunciation-assessment:
 *   post:
 *     summary: Assess user's pronunciation from an audio recording
 *     description: Upload an audio file and receive detailed pronunciation assessment
 *     tags: [PronunciationAssessment]
 *     security:
 *       - bearerAuth: []
 *     consumes:
 *       - multipart/form-data
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               audio:
 *                 type: string
 *                 format: binary
 *                 description: Audio file (supported formats - WAV, MP3, M4A)
 *               text:
 *                 type: string
 *                 description: Reference text to compare against
 *             required:
 *               - audio
 *               - text
 *     responses:
 *       200:
 *         description: Successful assessment
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 accuracyScore:
 *                   type: number
 *                   description: Overall pronunciation accuracy (0-100)
 *                 fluencyScore:
 *                   type: number
 *                   description: Speech fluency score (0-100)
 *                 completenessScore:
 *                   type: number
 *                   description: Completion ratio of the reference text
 *                 feedback:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       word:
 *                         type: string
 *                       score:
 *                         type: number
 *                       suggestions:
 *                         type: string
 *       400:
 *         description: Bad request
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *                   example: "Invalid file format or missing required fields"
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *                   example: "Authentication required"
 *       413:
 *         description: Payload too large
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *                   example: "Audio file size exceeds limit"
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *                   example: "Internal server error"
 */
router.post(
  "/",
  // authenticate,
  upload.single("audio"),
  assessPronunciation
);

export default router;
