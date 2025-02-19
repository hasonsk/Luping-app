import swaggerJSDoc from "swagger-jsdoc";
import { PORT } from "./config.js";

const options = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "Luping API",
      version: "1.0.0",
      description: "API documentation for Luping",
    },
    servers: [
      {
        url: `http://localhost:${PORT}/api`,
        description: "Development server",
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: "http",
          scheme: "bearer",
          bearerFormat: "JWT",
        },
      },
    },
    security: [
      {
        bearerAuth: [],
      },
    ],
  },
  apis: ["./src/routes/*.js"],
};

const swaggerSpec = swaggerJSDoc(options);

export default swaggerSpec;
