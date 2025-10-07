import { drizzle } from 'drizzle-orm/node-postgres';
import { Client } from 'pg';
import { compare } from 'bcryptjs';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

async function testAuthentication() {
  console.log('Testing admin user authentication...');
  
  try {
    // Create database client
    const client = new Client({
      connectionString: process.env.DATABASE_URL || 'postgresql://anzwa:anzwa@localhost:5432/feminafitgym',
    });
    
    await client.connect();
    console.log('Connected to database');
    
    // Find the admin user
    const getUserQuery = `
      SELECT id, email, salt, hash, first_name, last_name, role 
      FROM users 
      WHERE email = $1
    `;
    const userResult = await client.query(getUserQuery, ['admin@example.com']);
    
    if (userResult.rows.length === 0) {
      console.log('Admin user not found');
      await client.end();
      return;
    }
    
    const user = userResult.rows[0];
    console.log('Found user:', {
      id: user.id,
      email: user.email,
      firstName: user.first_name,
      lastName: user.last_name,
      role: user.role
    });
    
    // Test password
    const password = "password123";
    const isPasswordValid = await compare(password, user.hash);
    console.log('Password valid:', isPasswordValid);
    
    await client.end();
    console.log('Authentication test completed successfully!');
  } catch (error) {
    console.error('Error testing authentication:', error);
    process.exit(1);
  }
}

testAuthentication();