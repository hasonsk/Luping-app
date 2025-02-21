import * as textToSpeechService from "../services/textToSpeechService.js";
import path from "path";
import logger from "../configs/logger.js";

const synthesizeText = async (req, res, next) => {
  try {
    const { text } = req.body;

    if (!text) {
      const err = new Error("Text is required for speech synthesis.");
      err.status = 400;
      throw err;
    }

    const audioFilePath = await textToSpeechService.textToSpeech(text);

    // Set the appropriate headers for audio content
    res.setHeader('Content-Type', 'audio/wav');
    res.setHeader('Content-Disposition', 'inline; filename="speech.wav"');

    // Send the file as a response
    res.sendFile(path.resolve(audioFilePath), {
      headers: {
        'Content-Type': 'audio/wav',
      }
    }, (err) => {
      if (err) {
        logger.error("Error sending file:", err);
        next(err); // Pass errors to the error handler
      } else {
        logger.info("File sent successfully");
      }
    });
  } catch (error) {
    next(error); // Pass errors to the error handler
  }
};

export { synthesizeText };
