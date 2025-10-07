import express from 'express';
import payload from 'payload';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

const app = express();

// Initialize Payload without the conflicting Drizzle schema sync
await payload.init({
  secret: process.env.PAYLOAD_SECRET || 'very-long-secret-key-for-payload-cms',
  express: app,
  config: (await import('../payload.config.ts')).default,
  onInit: async () => {
    payload.logger.info(`Payload Admin URL: ${payload.getAdminURL()}`);
    console.log(`Admin panel available at: http://localhost:3000/admin`);
  },
});

// Important: Don't use any Drizzle schema sync code that might conflict with PayloadCMS

// The payload plugin automatically adds the admin routes
// No additional route configuration is needed

// Start the server on the default PayloadCMS port
const server = app.listen(3000, async () => {
  console.log('PayloadCMS server running on port 3000');
  console.log('Admin panel available at: http://localhost:3000/admin');
});

export { server };