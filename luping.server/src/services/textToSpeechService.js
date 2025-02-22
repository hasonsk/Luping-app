import * as sdk from "microsoft-cognitiveservices-speech-sdk";
import {
  AZURE_SPEECH_SERVICE_SUBSCRIPTION_KEY,
  AZURE_SPEECH_SERVICE_REGION,
} from "../configs/config.js";
import fs from "fs/promises";
import path from "path";
import logger from "../configs/logger.js";

const sanitizeText = (text) => {
  // Unicode range for common CJK Unified Ideographs (covers most Chinese characters)
  const chineseRegex = /[\u4E00-\u9FA5]/;

  let sanitized = "";
  for (const char of text.toLowerCase()) {
    if (/[a-z0-9]/.test(char) || chineseRegex.test(char)) {
      sanitized += char;
    } else {
      sanitized += "-";
    }
  }

  // Remove leading/trailing hyphens and collapse multiple hyphens
  sanitized = sanitized.replace(/^-+|-+$/g, "").replace(/-+/g, "-");
  return sanitized;
};

const textToSpeech = async (text) => {
  const sanitizedText = sanitizeText(text);
  const fileName = `${sanitizedText}.wav`;
  const filePath = path.join("tts", fileName);
  const ttsDirectory = path.join(".", "tts");
  try {
    // Check if file already exists
    await fs.access(filePath);
    logger.info(`Using cached file: ${fileName}`);
    return filePath; // Return existing file path
  } catch (error) {
    // File doesn't exist, proceed with synthesis
    // logger.info(`Synthesizing new audio for: ${text}`);
  }

  const speechConfig = sdk.SpeechConfig.fromSubscription(
    AZURE_SPEECH_SERVICE_SUBSCRIPTION_KEY,
    AZURE_SPEECH_SERVICE_REGION
  );
  speechConfig.speechSynthesisVoiceName = "zh-CN-XiaochenNeural";

  const audioConfig = sdk.AudioConfig.fromAudioFileOutput(filePath);
  const synthesizer = new sdk.SpeechSynthesizer(speechConfig, audioConfig);

  return new Promise((resolve, reject) => {
    synthesizer.speakTextAsync(
      text,
      async (result) => {
        if (result.reason === sdk.ResultReason.SynthesizingAudioCompleted) {
          logger.info(`Synthesis finished for: ${text}`);

          // Validate the WAV file before conversion
          try {
            const stats = await fs.stat(filePath);
            logger.info(`WAV file size: ${stats.size}`);
            if (stats.size < 100) {
              // Arbitrary threshold; adjust if needed
              throw new Error(
                "Synthesized audio file is too small or invalid."
              );
            }
          } catch (statError) {
            logger.error(`WAV file validation error: ${statError.message}`);
            synthesizer.close();
            return reject(new Error("Invalid audio file produced."));
          }

          resolve(filePath);
        } else {
          logger.error(`Speech synthesis canceled: ${result.errorDetails}`);
          reject(new Error("Text to speech failed: " + result.errorDetails));
        }
        synthesizer.close();
      },
      (err) => {
        logger.error(`Error synthesizing speech: ${err}`);
        synthesizer.close();
        reject(new Error("Text to speech failed: " + err));
      }
    );
  });
};

export { textToSpeech };
