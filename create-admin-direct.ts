import { drizzle } from 'drizzle-orm/node-postgres';
import { Client } from 'pg';
import { hash } from 'bcryptjs';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

async function createAdminUser() {
  console.log('Creating admin user directly in database...');
  
  try {
    // Create database client
    const client = new Client({
      connectionString: process.env.DATABASE_URL || 'postgresql://anzwa:anzwa@localhost:5432/feminafitgym',
    });
    
    await client.connect();
    console.log('Connected to database');
    
    // Hash the password
    const saltRounds = 10;
    const password = "password123";
    const hashedPassword = await hash(password, saltRounds);
    
    // Check if admin user already exists
    const existingUserQuery = `
      SELECT id FROM users WHERE email = $1
    `;
    const existingUserResult = await client.query(existingUserQuery, ['admin@example.com']);
    
    if (existingUserResult.rows.length > 0) {
      console.log('Admin user already exists');
      await client.end();
      return;
    }
    
    // Insert admin user directly into database
    const insertUserQuery = `
      INSERT INTO users (
        email, 
        salt, 
        hash, 
        first_name, 
        last_name, 
        auth_provider, 
        email_verified, 
        role, 
        created_at, 
        updated_at
      ) VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8, NOW(), NOW()
      ) RETURNING id
    `;
    
    const userValues = [
      'admin@example.com',
      hashedPassword.split('$')[2], // Extract salt from bcrypt hash
      hashedPassword, // Full bcrypt hash
      'Admin',
      'User',
      'email',
      true,
      'admin'
    ];
    
    const result = await client.query(insertUserQuery, userValues);
    console.log('Admin user created successfully!');
    console.log('User ID:', result.rows[0].id);
    console.log('Email: admin@example.com');
    console.log('Password: password123');
    
    await client.end();
  } catch (error) {
    console.error('Error creating admin user:', error);
    process.exit(1);
  }
}

createAdminUser();