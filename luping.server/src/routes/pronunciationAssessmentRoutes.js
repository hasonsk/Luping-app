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
 *                 Id:
 *                   type: string
 *                   description: Unique identifier for the assessment
 *                 RecognitionStatus:
 *                   type: string
 *                   description: Status of the speech recognition
 *                 Offset:
 *                   type: integer
 *                   description: Time offset in microseconds
 *                 Duration:
 *                   type: integer
 *                   description: Duration in microseconds
 *                 Channel:
 *                   type: integer
 *                   description: Audio channel number
 *                 DisplayText:
 *                   type: string
 *                   description: Recognized text with punctuation
 *                 SNR:
 *                   type: number
 *                   description: Signal-to-noise ratio
 *                 NBest:
 *                   type: array
 *                   description: Array of recognition results ordered by confidence
 *                   items:
 *                     type: object
 *                     properties:
 *                       Confidence:
 *                         type: number
 *                         description: Confidence score of the recognition
 *                       Lexical:
 *                         type: string
 *                         description: Raw recognized text
 *                       ITN:
 *                         type: string
 *                         description: Inverse text normalized form
 *                       MaskedITN:
 *                         type: string
 *                         description: Masked inverse text normalized form
 *                       Display:
 *                         type: string
 *                         description: Display text with punctuation
 *                       PronunciationAssessment:
 *                         type: object
 *                         properties:
 *                           AccuracyScore:
 *                             type: number
 *                             description: Overall pronunciation accuracy (0-100)
 *                           FluencyScore:
 *                             type: number
 *                             description: Speech fluency score (0-100)
 *                           CompletenessScore:
 *                             type: number
 *                             description: Completion ratio of the reference text
 *                           PronScore:
 *                             type: number
 *                             description: Overall pronunciation score
 *                       Words:
 *                         type: array
 *                         description: Word-level assessment details
 *                         items:
 *                           type: object
 *                           properties:
 *                             Word:
 *                               type: string
 *                               description: The assessed word
 *                             Offset:
 *                               type: integer
 *                               description: Time offset in microseconds
 *                             Duration:
 *                               type: integer
 *                               description: Duration in microseconds
 *                             PronunciationAssessment:
 *                               type: object
 *                               properties:
 *                                 AccuracyScore:
 *                                   type: number
 *                                   description: Word pronunciation accuracy
 *                                 ErrorType:
 *                                   type: string
 *                                   description: Type of pronunciation error if any
 *                             Syllables:
 *                               type: array
 *                               description: Syllable-level assessment details
 *                               items:
 *                                 type: object
 *                                 properties:
 *                                   Syllable:
 *                                     type: string
 *                                     description: The syllable
 *                                   PronunciationAssessment:
 *                                     type: object
 *                                     properties:
 *                                       AccuracyScore:
 *                                         type: number
 *                                         description: Syllable pronunciation accuracy
 *                                   Offset:
 *                                     type: integer
 *                                     description: Time offset in microseconds
 *                                   Duration:
 *                                     type: integer
 *                                     description: Duration in microseconds
 *                             Phonemes:
 *                               type: array
 *                               description: Phoneme-level assessment details
 *                               items:
 *                                 type: object
 *                                 properties:
 *                                   Phoneme:
 *                                     type: string
 *                                     description: The phoneme with tone number
 *                                   PronunciationAssessment:
 *                                     type: object
 *                                     properties:
 *                                       AccuracyScore:
 *                                         type: number
 *                                         description: Phoneme pronunciation accuracy
 *                                   Offset:
 *                                     type: integer
 *                                     description: Time offset in microseconds
 *                                   Duration:
 *                                     type: integer
 *                                     description: Duration in microseconds
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
