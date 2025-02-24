// test_websocket.js
import WebSocket from "ws";
import crypto from "crypto";
import dotenv from "dotenv";
dotenv.config();

function getAuthUrl(hostUrl, apiKey, apiSecret) {
  const url = new URL(hostUrl);
  const date = new Date().toGMTString();
  const builder = `host: ${url.host}\ndate: ${date}\nGET ${url.pathname} HTTP/1.1`;

  // Use APISecret for the HMAC
  const hmac = crypto.createHmac("sha256", apiSecret);
  hmac.update(builder);
  const signature = hmac.digest("base64");

  // Use APIKey in the authorization_origin string
  const authorization_origin = `api_key="${apiKey}", algorithm="hmac-sha256", headers="host date request-line", signature="${signature}"`; // Corrected: Use apiKey here
  const authorization = Buffer.from(authorization_origin).toString("base64");

  return `${hostUrl}?authorization=${authorization}&date=${date}&host=${url.host}`;
}

const authUrl = getAuthUrl(
  process.env.IFLYTEK_API_URL,
  process.env.IFLYTEK_API_KEY,
  process.env.IFLYTEK_API_SECRET,
);

const ws = new WebSocket(authUrl);

ws.on("open", () => {
  console.log("WebSocket connected!");
  ws.close(); // Close immediately after connecting
});

ws.on("close", (code, reason) => {
  console.log(`WebSocket closed: ${code} - ${reason.toString()}`);
});

ws.on("error", (error) => {
  console.error("WebSocket error:", error.message);
});
