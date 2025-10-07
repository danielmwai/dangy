import { Client } from 'pg';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

export async function verifyAdminUser() {
  console.log("Verifying admin user...");
  
  try {
    // Create database client
    const client = new Client({
      connectionString: process.env.DATABASE_URL || 'postgresql://anzwa:anzwa@localhost:5432/feminafitgym',
    });
    
    await client.connect();
    console.log("Connected to database");
    
    // Check if admin user exists
    const result = await client.query(
      'SELECT id, email, first_name, last_name, role FROM users WHERE email = $1',
      ['admin@example.com']
    );
    
    if (result.rows.length > 0) {
      const user = result.rows[0];
      console.log("✅ Admin user verified:");
      console.log(`   ID: ${user.id}`);
      console.log(`   Email: ${user.email}`);
      console.log(`   Name: ${user.first_name} ${user.last_name}`);
      console.log(`   Role: ${user.role}`);
      await client.end();
      return true;
    } else {
      console.log("❌ Admin user not found");
      await client.end();
      return false;
    }
  } catch (error) {
    console.error("Error verifying admin user:", error);
    return false;
  }
}

// Test the function
verifyAdminUser().then(() => {
  console.log("Verification complete");
});