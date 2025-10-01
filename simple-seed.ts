import { db } from "./server/db";
import { users } from "@shared/schema";
import { hash } from "bcryptjs";

async function seed() {
  console.log("Testing database connection and adding a simple user...");
  
  try {
    // Insert a simple test user
    console.log("Adding test user...");
    const password = await hash("password123", 10);
    const [user] = await db.insert(users).values({
      email: "test@example.com",
      password: password,
      firstName: "Test",
      lastName: "User",
      authProvider: "email",
      emailVerified: true
    }).returning();
    
    console.log("Successfully added user:", user.email);
    console.log("Database connection is working!");
  } catch (error) {
    console.error("Error seeding database:", error);
    process.exit(1);
  }
}

seed();