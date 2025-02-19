import express from "express";
import connectDB from "./configs/db.js";
import cors from "cors";
import http from "http";

import { PORT, NODE_ENV } from "./configs/config.js";
import loggerMiddlware from "./middlewares/logger.js";
import errorHandler from "./middlewares/errorHandler.js";
// import seedDB from './data_seeder/seed.js';
import logger from "./configs/logger.js";

import userRoutes from "./routes/userRoutes.js";
import chatBotRoutes from "./routes/chatBotRoutes.js";
import pronunciationAssessmentRoutes from "./routes/pronunciationAssessmentRoutes.js";

// Swagger setup
import swaggerUi from "swagger-ui-express";
import swaggerSpec from "./configs/swaggerConfig.js";

const app = express();

// Create HTTP server and attach Socket.io
const server = http.createServer(app);

// Allow all origins (development)
app.use(cors());

// Middleware to parse incoming JSON requests
app.use(express.json());

// Custom logging middleware
app.use(loggerMiddlware);

// Serve Swagger docs at /api-docs
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Serve Swagger JSON spec
app.get("/swagger.json", (req, res) => {
  res.setHeader("Content-Type", "application/json");
  res.send(swaggerSpec);
});

// Index route
app.get("/", (req, res) => {
  res.send("API is working, IP: " + req.ip);
});

// Index route
app.get("/api", (req, res) => {
  res.send("API is working, IP: " + req.ip);
});

// Mount routes
app.use("/api/users", userRoutes);
app.use("/api/chatbot", chatBotRoutes);
app.use("/api/pronunciation-assessment", pronunciationAssessmentRoutes);

// 404 handler
app.use((req, res, next) => {
  res.status(404).json({ message: "Resource not found" });
});

// Centralized error handling middleware
app.use(errorHandler);

// Connect to MongoDB and start the server only if not in test
if (NODE_ENV !== "test") {
  connectDB()
    .then(() => {
      // seedDB();
      server.listen(PORT, () => {
        logger.info(`Server running on port ${PORT} in ${NODE_ENV} mode`);
        logger.info(`SwaggerUI available at http://localhost:${PORT}/api-docs`);
        logger.info(
          `Swagger JSON spec available at http://localhost:${PORT}/swagger.json`,
        );
        logger.info(`Mongo Express available at http://localhost:8081`);
      });
    })
    .catch((err) => {
      logger.error("Error starting server:", err.message);
      process.exit(1);
    });
}
