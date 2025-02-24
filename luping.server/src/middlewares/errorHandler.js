import logger from "../configs/logger.js";

/**
 * Handles errors centrally and sends appropriate responses.
 * @param {Error} err - The error object.
 * @param {Express.Request} req - The incoming request object.
 * @param {Express.Response} res - The outgoing response object.
 * @param {Function} next - The next middleware function.
 */
const errorHandler = (err, req, res, next) => {
  logger.error(
    `${err.status || 500} - ${err.message} - ${req.originalUrl} - ${req.method} - ${req.ip} - ${err.stack}`,
  );

  const response = {
    type: "about:blank",
    title: err.message || "Internal Server Error",
    status: err.status || 500,
    detail: err.detail || "An unexpected error occurred.",
    instance: req.originalUrl,
  };

  res.status(err.status || 500).json(response);
};

export default errorHandler;
