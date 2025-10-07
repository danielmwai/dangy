import express, { type Request, Response, NextFunction } from "express";
import cookieParser from "cookie-parser";
import payload from 'payload';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

// Load environment variables
dotenv.config();

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

// Get the current directory equivalent for ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Initialize Payload without auto-pushing schema
await payload.init({
  secret: process.env.PAYLOAD_SECRET || 'default-dev-secret',
  express: app,
  config: (await import('./payload.config.ts')).default,
  onInit: async () => {
    payload.logger.info(`Payload Admin URL: ${payload.getAdminURL()}`);
  },
});

// Serve admin panel assets if in development
if (process.env.NODE_ENV === 'development') {
  const { createViteServer } = await import('./vite.js'); // Assuming a vite setup exists
  const vite = await createViteServer();
  app.use(vite.middlewares);
} else {
  app.use('/admin', express.static(path.resolve(__dirname, '../client/dist/admin')));
}

// Create the server and listen on the specified port
const port = parseInt(process.env.PORT || '5000', 10);
const server = app.listen({ 
  port,
  host: "0.0.0.0",
  reusePort: true,
}, () => {
  console.log(`Server running on port ${port}`);
  console.log(`Admin panel available at: http://localhost:${port}/admin`);
});

// Add error handling
app.use((err: any, req: Request, res: Response, next: NextFunction) => {
  const status = err.status || err.statusCode || 500;
  const message = err.message || "Internal Server Error";
  
  console.error(err);
  res.status(status).json({ message });
});

export { server, app };