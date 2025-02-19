import fs from "fs";
import crypto from "crypto";
import {
  IFLYTEK_APP_ID,
  IFLYTEK_API_KEY,
  IFLYTEK_API_SECRET,
  IFLYTEK_API_URL,
} from "../configs/config.js";
import logger from "../configs/logger.js";
import WebSocket from "ws";
import { parseStringPromise } from "xml2js"; // Import xml2js

function getAuthUrl(hostUrl, apiKey, apiSecret) {
  const url = new URL(hostUrl);
  const date = new Date().toGMTString();
  const builder = `host: ${url.host}\ndate: ${date}\nGET ${url.pathname} HTTP/1.1`;

  const hmac = crypto.createHmac("sha256", apiSecret);
  hmac.update(builder);
  const signature = hmac.digest("base64");

  const authorization_origin = `api_key="${apiKey}", algorithm="hmac-sha256", headers="host date request-line", signature="${signature}"`;
  const authorization = Buffer.from(authorization_origin).toString("base64");

  return `${hostUrl}?authorization=${authorization}&date=${date}&host=${url.host}`;
}

// Function to compare recognized text with target text and analyze errors
async function analyzePronunciation(parsedXml, targetText) {
  const result = {
    overallScore: parseFloat(
      parsedXml.xml_result.read_sentence[0].rec_paper[0].read_sentence[0].$
        .total_score,
    ),
    targetText: targetText,
    recognizedText: "",
    wordDetails: [],
    errors: [],
  };
  let recognizedText = "";
  if (
    parsedXml.xml_result.read_sentence[0].rec_paper[0].read_sentence[0].sentence
  ) {
    const words =
      parsedXml.xml_result.read_sentence[0].rec_paper[0].read_sentence[0]
        .sentence[0].word;

    for (const word of words) {
      const wordContent = word.$.content;
      recognizedText += wordContent;
      const wordDetail = {
        word: wordContent,
        pinyin: word.$.symbol,
        score: 0, // Initialize score
        syllables: [],
      };

      // Check total_score for word, it may not present.
      if (word.$.total_score) {
        wordDetail.score = parseFloat(word.$.total_score);
      }

      if (word.syll) {
        for (const syll of word.syll) {
          const syllContent = syll.$.content; // Corrected: Access as a string
          const dpMessage = parseInt(syll.$.dp_message);
          const syllDetail = {
            syllable: syllContent,
            pinyin: syll.$.symbol,
            dpMessage: dpMessage,
          };

          wordDetail.syllables.push(syllDetail);

          if (dpMessage !== 0) {
            result.errors.push({
              word: wordContent,
              syllable: syllContent,
              dpMessage: dpMessage,
              message: getDpMessageMeaning(dpMessage), // Helper function
            });
          }
        }
      }

      result.wordDetails.push(wordDetail);
    }
  }
  result.recognizedText = recognizedText;

  return result;
}

function getDpMessageMeaning(dpMessage) {
  switch (dpMessage) {
    case 0:
      return "Correct";
    case 16:
      return "Missed";
    case 32:
      return "Added";
    case 64:
      return "Readback";
    case 128:
      return "Replaced";
    default:
      return "Unknown Error";
  }
}
const evaluatePronunciation = (audioFilePath, textToEvaluate) => {
  return new Promise((resolve, reject) => {
    const authUrl = getAuthUrl(
      IFLYTEK_API_URL,
      IFLYTEK_API_KEY,
      IFLYTEK_API_SECRET,
    );
    const ws = new WebSocket(authUrl);

    ws.on("open", () => {
      logger.info("WebSocket connection opened");

      // Send initial configuration (ssb)
      // *** CRITICAL CHANGE: Add rstcd: "utf8" ***
      const ssbData = {
        common: {
          app_id: IFLYTEK_APP_ID,
        },
        business: {
          sub: "ise",
          ent: "cn_vip", // Or "en_vip" for English
          category: "read_sentence", // Adjust as needed
          cmd: "ssb",
          text: `\uFEFF${textToEvaluate}`, // Add UTF-8 BOM
          tte: "utf-8",
          ttp_skip: true,
          aue: "raw",
          auf: "audio/L16;rate=16000",
          rst: "entirety",
          ise_unite: "0",
          rstcd: "utf8", //  Force UTF-8 encoding for the result.
        },
        data: {
          status: 0,
        },
      };
      ws.send(JSON.stringify(ssbData));

      // Read and send audio data in chunks
      const stream = fs.createReadStream(audioFilePath, {
        highWaterMark: 1280,
      }); // 1280 bytes per chunk (40ms at 16kHz, 16-bit, mono)
      let frameCount = 0;

      stream.on("data", (chunk) => {
        frameCount++;
        const base64Data = chunk.toString("base64");
        let status, aus;

        if (frameCount === 1) {
          status = 1;
          aus = 1;
        } else {
          status = 1;
          aus = 2;
        }

        const auwData = {
          business: {
            cmd: "auw",
            aus: aus,
          },
          data: {
            status: status,
            data: base64Data,
          },
        };
        ws.send(JSON.stringify(auwData));
      });

      stream.on("end", () => {
        // Send the final frame
        const finalAuwData = {
          business: {
            cmd: "auw",
            aus: 4,
          },
          data: {
            status: 2,
            data: "", // Empty data for the last frame
          },
        };
        ws.send(JSON.stringify(finalAuwData));
      });
      stream.on("error", (error) => {
        logger.error(`Stream read error: ${error.message}`);
        reject(error);
        ws.close();
      });
    });

    ws.on("message", async (data) => {
      // <--- Make this callback async
      const result = JSON.parse(data);
      // logger.info(`Received message: ${JSON.stringify(result)}`); // Log the raw response
      if (result.code !== 0) {
        reject(
          new Error(
            `IFLYTEK API error: ${result.message} (code: ${result.code})`,
          ),
        );
        ws.close();
        return;
      }

      if (result.data && result.data.status === 2) {
        // All results received
        // resolve(result.data); // Resolve with the complete result
        logger.info(`Received message: ${JSON.stringify(result)}`);
        try {
          // Decode the Base64 data *before* parsing
          const decodedXml = Buffer.from(result.data.data, "base64").toString(
            "utf8",
          );

          const parsedXml = await parseStringPromise(decodedXml); // Parse the XML

          const analysis = await analyzePronunciation(
            parsedXml,
            textToEvaluate,
          );
          resolve(analysis); // Resolve with the analysis result
        } catch (parseError) {
          reject(new Error(`XML parsing error: ${parseError.message}`));
        }
      }
    });

    ws.on("close", (code, reason) => {
      logger.info(`WebSocket connection closed: ${code} - ${reason}`);
      if (code !== 1000) {
        reject(new Error(`WebSocket closed unexpectedly: ${code} - ${reason}`));
      }
    });

    ws.on("error", (error) => {
      logger.error(`WebSocket error: ${error.message}`);
      reject(error);
    });
  });
};

export { evaluatePronunciation };
