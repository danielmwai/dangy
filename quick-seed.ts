import { db } from "./server/db";
import {
  users,
  fitnessClasses,
  membershipPlans,
  products,
  productCategories,
  testimonials,
} from "./shared/schema";
import { hash } from "bcryptjs";

async function seed() {
  console.log("Seeding database...");
  
  try {
    const password = await hash("admin123", 10);
    await db.insert(users).values({
      email: "admin@feminafit.com",
      password,
      firstName: "Admin",
      lastName: "User",
      authProvider: "email",
      emailVerified: true,
      role: "admin"
    });
    
    await db.insert(fitnessClasses).values([
      { name: "Morning Yoga", description: "Start your day with yoga", duration: 60, level: "beginner", instructor: "Sarah Johnson", active: true },
      { name: "HIIT Training", description: "High-intensity interval training", duration: 45, level: "intermediate", instructor: "Mike Williams", active: true }
    ]);
    
    await db.insert(membershipPlans).values([
      { name: "Basic", description: "Perfect for beginners", price: "2999", duration: 30, features: '["Gym access", "1 class/month"]', popular: false, active: true },
      { name: "Premium", description: "Most popular", price: "4999", duration: 30, features: '["Gym access", "Unlimited classes"]', popular: true, active: true }
    ]);
    
    const categories = await db.insert(productCategories).values([
      { name: "Apparel", description: "Workout clothing", active: true }
    ]).returning();
    
    await db.insert(products).values([
      { name: "Sports Bra", description: "High-support sports bra", price: "1999", categoryId: categories[0].id, stock: 50, featured: true, active: true }
    ]);
    
    await db.insert(testimonials).values([
      { name: "Jane Doe", text: "FeminaFit transformed my fitness journey!", rating: 5, featured: true }
    ]);
    
    console.log("✅ Database seeded!");
    process.exit(0);
  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  }
}

seed();
