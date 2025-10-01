import { db } from "./server/db";
import {
  users,
  fitnessClasses,
  classSchedules,
  membershipPlans,
  products,
  productCategories,
  testimonials,
  pages
} from "@shared/schema";
import { hash } from "bcryptjs";

async function seed() {
  console.log("Seeding database with dummy data...");
  
  try {
    // Insert dummy users
    console.log("Adding users...");
    const password = await hash("password123", 10);
    const [adminUser] = await db.insert(users).values({
      email: "admin@example.com",
      password: password,
      firstName: "Admin",
      lastName: "User",
      authProvider: "email",
      emailVerified: true,
      role: "admin"
    }).returning();
    
    const [memberUser] = await db.insert(users).values({
      email: "member@example.com",
      password: password,
      firstName: "John",
      lastName: "Doe",
      authProvider: "email",
      emailVerified: true,
      role: "user"
    }).returning();
    
    // Insert fitness classes
    console.log("Adding fitness classes...");
    const [yogaClass] = await db.insert(fitnessClasses).values({
      name: "Morning Yoga",
      description: "Start your day with calming yoga poses and breathing techniques",
      duration: 60,
      level: "beginner",
      instructor: "Sarah Johnson",
      maxCapacity: 20,
      active: true
    }).returning();
    
    const [hiitClass] = await db.insert(fitnessClasses).values({
      name: "HIIT Training",
      description: "High-intensity interval training to burn calories and build strength",
      duration: 45,
      level: "intermediate",
      instructor: "Mike Williams",
      maxCapacity: 15,
      active: true
    }).returning();
    
    const [pilatesClass] = await db.insert(fitnessClasses).values({
      name: "Pilates Core",
      description: "Focus on core strength and stability with pilates exercises",
      duration: 50,
      level: "advanced",
      instructor: "Emma Davis",
      maxCapacity: 12,
      active: true
    }).returning();
    
    // Insert class schedules
    console.log("Adding class schedules...");
    await db.insert(classSchedules).values({
      classId: yogaClass.id,
      dayOfWeek: 1, // Monday
      startTime: "07:00",
      endTime: "08:00"
    });
    
    await db.insert(classSchedules).values({
      classId: yogaClass.id,
      dayOfWeek: 3, // Wednesday
      startTime: "07:00",
      endTime: "08:00"
    });
    
    await db.insert(classSchedules).values({
      classId: hiitClass.id,
      dayOfWeek: 2, // Tuesday
      startTime: "18:00",
      endTime: "18:45"
    });
    
    await db.insert(classSchedules).values({
      classId: hiitClass.id,
      dayOfWeek: 4, // Thursday
      startTime: "18:00",
      endTime: "18:45"
    });
    
    await db.insert(classSchedules).values({
      classId: pilatesClass.id,
      dayOfWeek: 5, // Friday
      startTime: "19:00",
      endTime: "19:50"
    });
    
    // Insert membership plans
    console.log("Adding membership plans...");
    await db.insert(membershipPlans).values({
      name: "Basic Plan",
      description: "Access to gym facilities during standard hours",
      price: "1500.00",
      duration: 30,
      features: ["Gym access 6am-10pm", "1 free class per week", "Locker access"],
      popular: false,
      active: true
    });
    
    const [premiumPlan] = await db.insert(membershipPlans).values({
      name: "Premium Plan",
      description: "Unlimited access to all facilities and classes",
      price: "3000.00",
      duration: 30,
      features: ["24/7 gym access", "Unlimited classes", "Personal locker", "1 personal training session/month"],
      popular: true,
      active: true
    }).returning();
    
    const [vipPlan] = await db.insert(membershipPlans).values({
      name: "VIP Plan",
      description: "Premium access with additional perks",
      price: "5000.00",
      duration: 30,
      features: ["24/7 gym access", "Unlimited classes", "Premium locker", "3 personal training sessions/month", "Access to VIP lounge"],
      popular: false,
      active: true
    }).returning();
    
    // Insert product categories
    console.log("Adding product categories...");
    const [supplementsCategory] = await db.insert(productCategories).values({
      name: "Supplements",
      description: "Protein powders, vitamins and other supplements",
      active: true
    }).returning();
    
    const [apparelCategory] = await db.insert(productCategories).values({
      name: "Apparel",
      description: "Gym wear and accessories",
      active: true
    }).returning();
    
    // Insert products
    console.log("Adding products...");
    await db.insert(products).values({
      name: "Whey Protein 2lbs",
      description: "Premium whey protein powder for muscle recovery",
      price: "2500.00",
      categoryId: supplementsCategory.id,
      stock: 25,
      featured: true,
      active: true
    });
    
    await db.insert(products).values({
      name: "BCAA 30 Servings",
      description: "Branched-chain amino acids for muscle recovery",
      price: "1800.00",
      categoryId: supplementsCategory.id,
      stock: 15,
      featured: false,
      active: true
    });
    
    await db.insert(products).values({
      name: "Women's Sports Bra",
      description: "High-impact sports bra with moisture-wicking fabric",
      price: "800.00",
      categoryId: apparelCategory.id,
      stock: 30,
      featured: true,
      active: true
    });
    
    await db.insert(products).values({
      name: "Men's Gym Shorts",
      description: "Comfortable and flexible gym shorts",
      price: "600.00",
      categoryId: apparelCategory.id,
      stock: 20,
      featured: false,
      active: true
    });
    
    // Insert testimonials
    console.log("Adding testimonials...");
    await db.insert(testimonials).values({
      name: "Lisa Anderson",
      username: "@lisa_fit",
      text: "I've been a member for 6 months and have seen incredible results. The trainers are knowledgeable and the equipment is top-notch!",
      rating: 5,
      featured: true
    });
    
    await db.insert(testimonials).values({
      name: "Tom Wilson",
      username: "@tom_gym_rat",
      text: "The variety of classes keeps me motivated. The HIIT sessions with Mike are particularly challenging and effective.",
      rating: 4,
      featured: true
    });
    
    await db.insert(testimonials).values({
      name: "Emma Thompson",
      username: "@emma_health",
      text: "As a beginner, I appreciated the welcoming atmosphere. The staff took time to show me how to use the equipment properly.",
      rating: 5,
      featured: false
    });
    
    // Insert pages
    console.log("Adding pages...");
    await db.insert(pages).values({
      slug: "about",
      title: "About Us",
      content: JSON.stringify({
        "type": "doc",
        "content": [
          {
            "type": "heading",
            "attrs": { "level": 1 },
            "content": [{ "type": "text", "text": "Welcome to FeminaFit Gym" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "At FeminaFit, we're dedicated to providing a supportive and empowering environment for women to achieve their fitness goals. Our state-of-the-art facility offers a wide range of equipment, classes, and personalized training programs designed specifically with women's health and fitness in mind." }
            ]
          }
        ]
      }),
      metaDescription: "Learn about FeminaFit Gym and our mission to empower women through fitness",
      published: true
    });
    
    await db.insert(pages).values({
      slug: "contact",
      title: "Contact Us",
      content: JSON.stringify({
        "type": "doc",
        "content": [
          {
            "type": "heading",
            "attrs": { "level": 1 },
            "content": [{ "type": "text", "text": "Get in Touch" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "We'd love to hear from you! Reach out to us with any questions or to schedule a tour of our facility." }
            ]
          }
        ]
      }),
      metaDescription: "Contact information for FeminaFit Gym",
      published: true
    });
    
    // Privacy Policy page
    await db.insert(pages).values({
      slug: "privacy",
      title: "Privacy Policy",
      content: JSON.stringify({
        "type": "doc",
        "content": [
          {
            "type": "heading",
            "attrs": { "level": 1 },
            "content": [{ "type": "text", "text": "Privacy Policy" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "At FeminaFit, we are committed to protecting your privacy and safeguarding your personal information. This Privacy Policy explains how we collect, use, and protect your information when you use our website and services." }
            ]
          },
          {
            "type": "heading",
            "attrs": { "level": 2 },
            "content": [{ "type": "text", "text": "Information We Collect" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "We collect information you provide directly to us, such as when you create an account, purchase a membership, or contact us. This may include your name, email address, phone number, and payment information." }
            ]
          },
          {
            "type": "heading",
            "attrs": { "level": 2 },
            "content": [{ "type": "text", "text": "How We Use Your Information" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "We use your information to provide and improve our services, process transactions, communicate with you, and personalize your experience at our facilities." }
            ]
          },
          {
            "type": "heading",
            "attrs": { "level": 2 },
            "content": [{ "type": "text", "text": "Data Security" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction." }
            ]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "For more details about our privacy practices, please contact us at feminafit59@gmail.com" }
            ]
          }
        ]
      }),
      metaDescription: "Privacy policy for FeminaFit Gym - how we protect your personal information",
      published: true
    });
    
    // Terms of Service page
    await db.insert(pages).values({
      slug: "terms",
      title: "Terms of Service",
      content: JSON.stringify({
        "type": "doc",
        "content": [
          {
            "type": "heading",
            "attrs": { "level": 1 },
            "content": [{ "type": "text", "text": "Terms of Service" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "Welcome to FeminaFit! These Terms of Service govern your use of our website and services. By accessing or using FeminaFit, you agree to be bound by these terms." }
            ]
          },
          {
            "type": "heading",
            "attrs": { "level": 2 },
            "content": [{ "type": "text", "text": "Membership Terms" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "Memberships are personal to you and cannot be transferred. All memberships are subject to our current rates and terms, which may be updated from time to time." }
            ]
          },
          {
            "type": "heading",
            "attrs": { "level": 2 },
            "content": [{ "type": "text", "text": "Use of Facilities" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "Members agree to use our facilities safely and responsibly. Members must follow all posted rules and guidelines during their visit." }
            ]
          },
          {
            "type": "heading",
            "attrs": { "level": 2 },
            "content": [{ "type": "text", "text": "Cancellation Policy" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "You may cancel your membership with 30 days written notice. Refunds are subject to our refund policy and may vary depending on the type of membership and circumstances of cancellation." }
            ]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "For questions about our Terms of Service, please contact us at feminafit59@gmail.com" }
            ]
          }
        ]
      }),
      metaDescription: "Terms of service for FeminaFit Gym - rules and conditions for using our facilities",
      published: true
    });
    
    // Refund Policy page
    await db.insert(pages).values({
      slug: "refund",
      title: "Refund Policy",
      content: JSON.stringify({
        "type": "doc",
        "content": [
          {
            "type": "heading",
            "attrs": { "level": 1 },
            "content": [{ "type": "text", "text": "Refund Policy" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "At FeminaFit, we want you to be satisfied with your membership and purchases. Here's our policy regarding refunds:" }
            ]
          },
          {
            "type": "heading",
            "attrs": { "level": 2 },
            "content": [{ "type": "text", "text": "Membership Refunds" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "Membership fees are generally non-refundable after the first 30 days of membership. Exceptions may be made for documented medical reasons or relocation more than 50km from the facility." }
            ]
          },
          {
            "type": "heading",
            "attrs": { "level": 2 },
            "content": [{ "type": "text", "text": "Product Purchases" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "Unopened retail products may be returned within 14 days for a full refund. Opened items may be returned within 7 days if found to be defective." }
            ]
          },
          {
            "type": "heading",
            "attrs": { "level": 2 },
            "content": [{ "type": "text", "text": "Class Passes" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "Class passes are non-refundable but may be frozen under documented medical circumstances for up to 3 months." }
            ]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "To request a refund, please contact our membership services team with your receipt and reason for request." }
            ]
          }
        ]
      }),
      metaDescription: "Refund policy for FeminaFit Gym - information about returning products and memberships",
      published: true
    });
    
    // FAQ page
    await db.insert(pages).values({
      slug: "faq",
      title: "Frequently Asked Questions",
      content: JSON.stringify({
        "type": "doc",
        "content": [
          {
            "type": "heading",
            "attrs": { "level": 1 },
            "content": [{ "type": "text", "text": "Frequently Asked Questions" }]
          },
          {
            "type": "heading",
            "attrs": { "level": 2 },
            "content": [{ "type": "text", "text": "What are your operating hours?" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "We are open Monday through Friday from 5:00 AM to 10:00 PM and on weekends from 6:00 AM to 8:00 PM. Holiday hours may vary." }
            ]
          },
          {
            "type": "heading",
            "attrs": { "level": 2 },
            "content": [{ "type": "text", "text": "Do you offer day passes?" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "Yes, we offer day passes for KES 500. These can be purchased at the front desk or through our mobile app." }
            ]
          },
          {
            "type": "heading",
            "attrs": { "level": 2 },
            "content": [{ "type": "text", "text": "Can I bring a guest?" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "Members can bring guests for KES 700 per visit. VIP members receive 2 complimentary guest passes per month." }
            ]
          },
          {
            "type": "heading",
            "attrs": { "level": 2 },
            "content": [{ "type": "text", "text": "Are personal trainers available?" }]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "Yes, certified personal trainers are available for one-on-one sessions and small group training. Book in advance for the best availability." }
            ]
          },
          {
            "type": "paragraph",
            "content": [
              { "type": "text", "text": "For additional questions not covered here, please contact us directly." }
            ]
          }
        ]
      }),
      metaDescription: "Frequently asked questions about FeminaFit Gym membership, classes, and services",
      published: true
    });
    
    console.log("Database seeding completed successfully!");
    console.log("Added:");
    console.log("- 2 Users");
    console.log("- 3 Fitness Classes");
    console.log("- 5 Class Schedules");
    console.log("- 3 Membership Plans");
    console.log("- 2 Product Categories");
    console.log("- 4 Products");
    console.log("- 3 Testimonials");
    console.log("- 2 Pages");
  } catch (error) {
    console.error("Error seeding database:", error);
    process.exit(1);
  }
}

seed();