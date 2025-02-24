import mongoose from "mongoose";
import { MONGO_URI } from "./config.js";
import logger from "./logger.js";

const connectDB = async () => {
  try {
    const conn = await mongoose.connect(MONGO_URI);
    logger.info("Connected to MongoDB");
    return conn;
  } catch (err) {
    logger.error(`Error connecting to MongoDB: ${err.message}`);
    process.exit(1);
  }
};

export default connectDB;
