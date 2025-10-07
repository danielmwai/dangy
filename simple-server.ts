import express from 'express';
import payload from 'payload';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

console.log('PAYLOAD_SECRET:', process.env.PAYLOAD_SECRET);

// Get the directory name
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Create Express app
const app = express();

// Initialize Payload
const secret = process.env.PAYLOAD_SECRET || 'default-dev-secret';
console.log('Using secret:', secret ? 'Loaded from env' : 'Using default');

await payload.init({
  secret: secret,
  express: app,
  config: join(__dirname, 'payload.config.ts'),
  onInit: async () => {
    payload.logger.info(`Payload Admin URL: ${payload.getAdminURL()}`);
  },
});

// Serve static files for the frontend
app.use('/', express.static(join(__dirname, 'dist/public')));

// Handle all other routes with the frontend app
app.get('*', (req, res) => {
  res.sendFile(join(__dirname, 'dist/public/index.html'));
});

// Start the server
const port = process.env.PORT || 5000;
app.listen(port, () => {
  console.log(`🚀 Server running on http://localhost:${port}`);
  console.log(`🔒 Admin Panel: http://localhost:${port}/admin`);
});