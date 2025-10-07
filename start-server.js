import { spawn } from 'child_process';
import dotenv from 'dotenv';

dotenv.config();

console.log('Starting PayloadCMS server...');
console.log('Environment:', process.env.NODE_ENV || 'development');
console.log('Database URL:', process.env.DATABASE_URL ? 'Set' : 'Not set');
console.log('Payload Secret:', process.env.PAYLOAD_SECRET ? 'Set' : 'Not set');

const server = spawn('npx', ['tsx', 'server/index.ts'], {
  env: process.env,
  stdio: 'inherit'
});

server.on('error', (err) => {
  console.error('Failed to start server:', err);
});

server.on('close', (code) => {
  console.log(`Server process exited with code ${code}`);
});