import { convertToWav } from "../services/audioConversionService.js";
import { evaluatePronunciation } from "../services/pronunciationAssessmentService.js";
import logger from "../configs/logger.js";
import fs from "fs/promises";

const assessPronunciation = async (req, res, next) => {
  if (!req.file) {
    return res.status(400).json({ message: "No audio file uploaded." });
  }
  if (!req.body.text) {
    return res.status(400).json({ message: "No text provided." });
  }

  const audioFilePath = req.file.path;
  const textToEvaluate = req.body.text;
  let wavFilePath; // Declare wavFilePath here

  try {
    wavFilePath = await convertToWav(audioFilePath);
    const result = await evaluatePronunciation(wavFilePath, textToEvaluate);

    // result now contains the analyzed data
    await fs.unlink(audioFilePath);
    await fs.unlink(wavFilePath);

    res.status(200).json(result); // Send the full analysis
  } catch (error) {
    logger.error(`Pronunciation assessment error: ${error.message}`);

    //Attempt to remove files, even on error
    try {
      await fs.unlink(audioFilePath);
      if (wavFilePath) {
        // Check if wavFilePath is defined
        await fs.unlink(wavFilePath);
      }
    } catch (cleanupError) {
      // Log but do not throw to avoid masking the original error.
      logger.error(`Error during file cleanup: ${cleanupError.message}`);
    }

    next(error); // Pass the error to the error handling middleware.
  }
};

export { assessPronunciation };
