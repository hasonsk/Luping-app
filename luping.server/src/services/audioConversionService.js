import ffmpeg from "fluent-ffmpeg";
import ffmpegStatic from "ffmpeg-static";
import path from "path";
import fs from "fs";
import logger from "../configs/logger.js";

// Set the path to ffmpeg-static binary (if installed)
ffmpeg.setFfmpegPath(ffmpegStatic);

const convertToWav = async (inputFilePath) => {
  const fileExtension = path.extname(inputFilePath).toLowerCase();
  if (fileExtension === ".wav") {
    return inputFilePath; // Skip conversion
  }

  return new Promise((resolve, reject) => {
    const outputFilePath = path.join(
      "uploads",
      `${path.basename(inputFilePath, path.extname(inputFilePath))}.wav`
    );

    ffmpeg(inputFilePath)
      .audioCodec("pcm_s16le") // Convert to 16-bit PCM WAV
      .audioFrequency(16000) // 16 kHz sample rate
      .audioChannels(1) // Mono
      .format("wav")
      .on("end", () => {
        logger.info(`Audio converted successfully: ${outputFilePath}`);
        resolve(outputFilePath);
      })
      .on("error", (err) => {
        logger.error(`Audio conversion error: ${err.message}`);
        reject(new Error("Failed to convert audio to WAV format."));
      })
      .save(outputFilePath);
  });
};

export { convertToWav };
