import morgan from "morgan";
import logger from "../configs/logger.js";

const stream = {
  write: (message) => logger.info(message.trim()),
};

const morganMiddleware = morgan("combined", { stream });

export default morganMiddleware;
