import { createLogger, transports, format } from "winston";
import fs from "fs";

// Ensure logs folder exists
const logDir = "./logs";
if (!fs.existsSync(logDir)) {
  fs.mkdirSync(logDir);
}

const logger = createLogger({
  level: "info",
  format: format.combine(
    format.timestamp({ format: "YYYY-MM-DD HH:mm:ss" }) // Add timestamp
  ),
  transports: [
    // Console Log (Formatted)
    new transports.Console({
      format: format.combine(
        format.colorize(),
        format.printf(
          (info) => `[${info.timestamp}] ${info.level}: ${info.message}`
        )
      ),
    }),

    // Combined Log File (JSON Format)
    new transports.File({
      filename: "logs/combined.log",
      format: format.combine(format.json()),
    }),

    // Error Log File (JSON Format)
    new transports.File({
      filename: "logs/errors.log",
      level: "error",
      format: format.combine(format.json()),
    }),
  ],
});

export default logger;
