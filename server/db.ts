import Database from 'better-sqlite3';
import { drizzle } from 'drizzle-orm/better-sqlite3';
import * as schema from "@shared/schema";
import dotenv from 'dotenv';

// Load environment variables from .env file
dotenv.config();

const sqlite = new Database('feminafit.db');
export const db = drizzle(sqlite, { schema });
