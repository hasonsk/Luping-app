import { config } from "dotenv";

config();

export const PORT = process.env.PORT || 3000;
export const MONGO_URI = process.env.MONGO_URI;
export const JWT_SECRET = process.env.JWT_SECRET;
export const JWT_EXPIRATION = process.env.JWT_EXPIRATION || "1h";
export const JWT_REFRESH_EXPIRATION =
  process.env.JWT_REFRESH_EXPIRATION || "30d";
export const NODE_ENV = process.env.NODE_ENV || "development";

export const MAIL_USER = process.env.MAIL_USER;

export const CLOUDINARY_CLOUD_NAME = process.env.CLOUDINARY_CLOUD_NAME;
export const CLOUDINARY_API_KEY = process.env.CLOUDINARY_API_KEY;
export const CLOUDINARY_API_SECRET = process.env.CLOUDINARY_API_SECRET;

export const GEMINI_API_KEY = process.env.GEMINI_API_KEY;

export const LOG_LEVEL = process.env.LOG_LEVEL || "info";

export const IFLYTEK_APP_ID = process.env.IFLYTEK_APP_ID;
export const IFLYTEK_API_KEY = process.env.IFLYTEK_API_KEY;
export const IFLYTEK_API_SECRET = process.env.IFLYTEK_API_SECRET;
export const IFLYTEK_API_URL = process.env.IFLYTEK_API_URL;

export const AZURE_SPEECH_SERVICE_SUBSCRIPTION_KEY = process.env.AZURE_SPEECH_SERVICE_SUBSCRIPTION_KEY;
export const AZURE_SPEECH_SERVICE_REGION = process.env.AZURE_SPEECH_SERVICE_REGION;

export const mailConfig = {
  service: process.env.MAIL_SERVICE,
  host: process.env.MAIL_HOST,
  port: process.env.MAIL_PORT,
  secure: process.env.MAIL_SECURE === "true",
  auth: {
    user: process.env.MAIL_USER,
    pass: process.env.MAIL_PASS,
  },
};
