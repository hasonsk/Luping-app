import * as sdk from "microsoft-cognitiveservices-speech-sdk";
import {
  AZURE_SPEECH_SERVICE_SUBSCRIPTION_KEY,
  AZURE_SPEECH_SERVICE_REGION,
} from "../configs/config.js";
import logger from "../configs/logger.js";
import fs from "fs";

async function evaluatePronunciation(wavFilePath, referenceText) {
  if (!AZURE_SPEECH_SERVICE_SUBSCRIPTION_KEY || !AZURE_SPEECH_SERVICE_REGION) {
    throw new Error("Azure Speech Service credentials not configured.");
  }

  // Check if the file exists
  if (!fs.existsSync(wavFilePath)) {
    throw new Error(`WAV file not found: ${wavFilePath}`);
  }

  const speechConfig = sdk.SpeechConfig.fromSubscription(
    AZURE_SPEECH_SERVICE_SUBSCRIPTION_KEY,
    AZURE_SPEECH_SERVICE_REGION
  );

  // Set the speech recognition language to Chinese (zh-CN)
  speechConfig.speechRecognitionLanguage = "zh-CN";

  const audioConfig = sdk.AudioConfig.fromWavFileInput(
    fs.readFileSync(wavFilePath)
  );

  // Create the pronunciation assessment configuration.
  const pronunciationAssessmentConfig = new sdk.PronunciationAssessmentConfig(
    referenceText,
    sdk.PronunciationAssessmentGradingSystem.HundredMark,
    sdk.PronunciationAssessmentGranularity.Phoneme,
    true // Enable miscue
  );
  pronunciationAssessmentConfig.phonemeAlphabet = "SAPI";

  const recognizer = new sdk.SpeechRecognizer(speechConfig, audioConfig);
  pronunciationAssessmentConfig.applyTo(recognizer);

  return new Promise((resolve, reject) => {
    recognizer.recognizeOnceAsync(
      (result) => {
        if (result.reason === sdk.ResultReason.RecognizedSpeech) {
          const pronunciationResult = sdk.PronunciationAssessmentResult.fromResult(result);

          // Get the JSON result for more detailed information.
          const pronunciationResultJson = result.properties.getProperty(
            sdk.PropertyId.SpeechServiceResponse_JsonResult
          );

          // logger.info(
          //   `Pronunciation assessment result:\n ${pronunciationResultJson}`
          // );

          resolve(JSON.parse(pronunciationResultJson)); // Resolve with the parsed JSON
        } else if (result.reason === sdk.ResultReason.Canceled) {
          const cancellation = sdk.CancellationDetails.fromResult(result);
          logger.error(
            `Speech recognition canceled: ${cancellation.errorDetails}`
          );
          reject(
            new Error(
              `Speech recognition canceled: ${cancellation.errorDetails}`
            )
          );
        } else {
          logger.error(`Speech recognition failed. Reason: ${result.reason}`);
          reject(
            new Error(`Speech recognition failed. Reason: ${result.reason}`)
          );
        }
        recognizer.close();
      },
      (err) => {
        logger.error(`Error during speech recognition: ${err}`);
        reject(new Error(`Error during speech recognition: ${err}`));
        recognizer.close();
      }
    );
  });
}

export { evaluatePronunciation };
