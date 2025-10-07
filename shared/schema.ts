import { sql, relations } from "drizzle-orm";
import {
  index,
  sqliteTable,
  text,
  integer,
  real,
} from "drizzle-orm/sqlite-core";
import { createInsertSchema } from "drizzle-zod";
import { z } from "zod";
import { nanoid } from "nanoid";

// Session storage table (required for auth)
export const sessions = sqliteTable(
  "sessions",
  {
    sid: text("sid").primaryKey(),
    sess: text("sess").notNull(),
    expire: integer("expire").notNull(),
  },
  (table) => ({
    expireIdx: index("IDX_session_expire").on(table.expire),
  })
);

// User storage table (supports both Replit Auth and email/password auth)
export const users = sqliteTable("users", {
  id: text("id").primaryKey().$defaultFn(() => nanoid()),
  email: text("email").unique(),
  password: text("password"), // For email/password authentication
  firstName: text("first_name"),
  lastName: text("last_name"),
  profileImageUrl: text("profile_image_url"),
  authProvider: text("auth_provider").default("replit"), // 'replit' or 'email'
  emailVerified: integer("email_verified", { mode: 'boolean' }).default(false),
  role: text("role").default("user"), // 'user' or 'admin'
  createdAt: integer("created_at").$defaultFn(() => Date.now()),
  updatedAt: integer("updated_at").$defaultFn(() => Date.now()),
});

// Content management tables
export const pages = sqliteTable("pages", {
  id: text("id").primaryKey().$defaultFn(() => nanoid()),
  slug: text("slug").notNull().unique(),
  title: text("title").notNull(),
  content: text("content").notNull(), // JSON string
  metaDescription: text("meta_description"),
  published: integer("published", { mode: 'boolean' }).default(true),
  createdAt: integer("created_at").$defaultFn(() => Date.now()),
  updatedAt: integer("updated_at").$defaultFn(() => Date.now()),
});

export const testimonials = sqliteTable("testimonials", {
  id: text("id").primaryKey().$defaultFn(() => nanoid()),
  name: text("name").notNull(),
  username: text("username"),
  text: text("text").notNull(),
  rating: integer("rating").notNull().default(5),
  imageUrl: text("image_url"),
  featured: integer("featured", { mode: 'boolean' }).default(false),
  createdAt: integer("created_at").$defaultFn(() => Date.now()),
});

// Fitness classes
export const fitnessClasses = sqliteTable("fitness_classes", {
  id: text("id").primaryKey().$defaultFn(() => nanoid()),
  name: text("name").notNull(),
  description: text("description").notNull(),
  duration: integer("duration").notNull(), // in minutes
  level: text("level").notNull(), // beginner, intermediate, advanced
  instructor: text("instructor"),
  maxCapacity: integer("max_capacity").default(20),
  imageUrl: text("image_url"),
  active: integer("active", { mode: 'boolean' }).default(true),
  createdAt: integer("created_at").$defaultFn(() => Date.now()),
});

export const classSchedules = sqliteTable("class_schedules", {
  id: text("id").primaryKey().$defaultFn(() => nanoid()),
  classId: text("class_id").references(() => fitnessClasses.id),
  dayOfWeek: integer("day_of_week").notNull(), // 0-6
  startTime: text("start_time").notNull(), // HH:MM format
  endTime: text("end_time").notNull(),
  createdAt: integer("created_at").$defaultFn(() => Date.now()),
});

// Membership plans
export const membershipPlans = sqliteTable("membership_plans", {
  id: text("id").primaryKey().$defaultFn(() => nanoid()),
  name: text("name").notNull(),
  description: text("description").notNull(),
  price: real("price").notNull(),
  duration: integer("duration").notNull(), // in days
  features: text("features").notNull(), // JSON array of features
  popular: integer("popular", { mode: 'boolean' }).default(false),
  active: integer("active", { mode: 'boolean' }).default(true),
  createdAt: integer("created_at").$defaultFn(() => Date.now()),
});

export const memberships = sqliteTable("memberships", {
  id: text("id").primaryKey().$defaultFn(() => nanoid()),
  userId: text("user_id").references(() => users.id),
  planId: text("plan_id").references(() => membershipPlans.id),
  startDate: integer("start_date").notNull(),
  endDate: integer("end_date").notNull(),
  status: text("status").notNull().default("active"), // active, expired, cancelled
  createdAt: integer("created_at").$defaultFn(() => Date.now()),
});

// Products and e-commerce
export const productCategories = sqliteTable("product_categories", {
  id: text("id").primaryKey().$defaultFn(() => nanoid()),
  name: text("name").notNull(),
  description: text("description"),
  imageUrl: text("image_url"),
  active: integer("active", { mode: 'boolean' }).default(true),
});

export const products = sqliteTable("products", {
  id: text("id").primaryKey().$defaultFn(() => nanoid()),
  name: text("name").notNull(),
  description: text("description").notNull(),
  price: real("price").notNull(),
  categoryId: text("category_id").references(() => productCategories.id),
  imageUrl: text("image_url"),
  stock: integer("stock").default(0),
  featured: integer("featured", { mode: 'boolean' }).default(false),
  active: integer("active", { mode: 'boolean' }).default(true),
  createdAt: integer("created_at").$defaultFn(() => Date.now()),
});

export const orders = sqliteTable("orders", {
  id: text("id").primaryKey().$defaultFn(() => nanoid()),
  userId: text("user_id").references(() => users.id),
  total: real("total").notNull(),
  status: text("status").notNull().default("pending"), // pending, paid, shipped, delivered, cancelled
  shippingAddress: text("shipping_address"), // JSON string
  createdAt: integer("created_at").$defaultFn(() => Date.now()),
  updatedAt: integer("updated_at").$defaultFn(() => Date.now()),
});

export const orderItems = sqliteTable("order_items", {
  id: text("id").primaryKey().$defaultFn(() => nanoid()),
  orderId: text("order_id").references(() => orders.id),
  productId: text("product_id").references(() => products.id),
  quantity: integer("quantity").notNull(),
  price: real("price").notNull(),
});

// Payment transactions
export const payments = sqliteTable("payments", {
  id: text("id").primaryKey().$defaultFn(() => nanoid()),
  orderId: text("order_id").references(() => orders.id),
  membershipId: text("membership_id").references(() => memberships.id),
  amount: real("amount").notNull(),
  currency: text("currency").default("KES"),
  method: text("method").notNull(), // mpesa, card, cash
  status: text("status").notNull().default("pending"), // pending, completed, failed, refunded
  transactionId: text("transaction_id"),
  phoneNumber: text("phone_number"),
  mpesaData: text("mpesa_data"), // JSON string
  createdAt: integer("created_at").$defaultFn(() => Date.now()),
  updatedAt: integer("updated_at").$defaultFn(() => Date.now()),
});

// Newsletter subscriptions
export const newsletterSubscriptions = sqliteTable("newsletter_subscriptions", {
  id: text("id").primaryKey().$defaultFn(() => nanoid()),
  email: text("email").notNull().unique(),
  active: integer("active", { mode: 'boolean' }).default(true),
  createdAt: integer("created_at").$defaultFn(() => Date.now()),
});

// Contact form submissions
export const contactSubmissions = sqliteTable("contact_submissions", {
  id: text("id").primaryKey().$defaultFn(() => nanoid()),
  name: text("name").notNull(),
  email: text("email").notNull(),
  phone: text("phone"),
  message: text("message").notNull(),
  status: text("status").default("new"), // new, responded, closed
  createdAt: integer("created_at").$defaultFn(() => Date.now()),
});

// Relations
export const usersRelations = relations(users, ({ many }) => ({
  memberships: many(memberships),
  orders: many(orders),
}));

export const membershipPlansRelations = relations(membershipPlans, ({ many }) => ({
  memberships: many(memberships),
}));

export const membershipsRelations = relations(memberships, ({ one, many }) => ({
  user: one(users, {
    fields: [memberships.userId],
    references: [users.id],
  }),
  plan: one(membershipPlans, {
    fields: [memberships.planId],
    references: [membershipPlans.id],
  }),
  payments: many(payments),
}));

export const productCategoriesRelations = relations(productCategories, ({ many }) => ({
  products: many(products),
}));

export const productsRelations = relations(products, ({ one, many }) => ({
  category: one(productCategories, {
    fields: [products.categoryId],
    references: [productCategories.id],
  }),
  orderItems: many(orderItems),
}));

export const ordersRelations = relations(orders, ({ one, many }) => ({
  user: one(users, {
    fields: [orders.userId],
    references: [users.id],
  }),
  items: many(orderItems),
  payments: many(payments),
}));

export const orderItemsRelations = relations(orderItems, ({ one }) => ({
  order: one(orders, {
    fields: [orderItems.orderId],
    references: [orders.id],
  }),
  product: one(products, {
    fields: [orderItems.productId],
    references: [products.id],
  }),
}));

export const paymentsRelations = relations(payments, ({ one }) => ({
  order: one(orders, {
    fields: [payments.orderId],
    references: [orders.id],
  }),
  membership: one(memberships, {
    fields: [payments.membershipId],
    references: [memberships.id],
  }),
}));

export const fitnessClassesRelations = relations(fitnessClasses, ({ many }) => ({
  schedules: many(classSchedules),
}));

export const classSchedulesRelations = relations(classSchedules, ({ one }) => ({
  class: one(fitnessClasses, {
    fields: [classSchedules.classId],
    references: [fitnessClasses.id],
  }),
}));

// Insert schemas
export const insertUserSchema = createInsertSchema(users).omit({
  id: true,
  createdAt: true,
  updatedAt: true,
});

export const insertPageSchema = createInsertSchema(pages).omit({
  id: true,
  createdAt: true,
  updatedAt: true,
});

export const insertTestimonialSchema = createInsertSchema(testimonials).omit({
  id: true,
  createdAt: true,
});

export const insertFitnessClassSchema = createInsertSchema(fitnessClasses).omit({
  id: true,
  createdAt: true,
});

export const insertMembershipPlanSchema = createInsertSchema(membershipPlans).omit({
  id: true,
  createdAt: true,
});

export const insertProductSchema = createInsertSchema(products).omit({
  id: true,
  createdAt: true,
});

export const insertOrderSchema = createInsertSchema(orders).omit({
  id: true,
  createdAt: true,
  updatedAt: true,
});

export const insertNewsletterSubscriptionSchema = createInsertSchema(newsletterSubscriptions).omit({
  id: true,
  createdAt: true,
});

export const insertContactSubmissionSchema = createInsertSchema(contactSubmissions).omit({
  id: true,
  createdAt: true,
});

// Types
export type UpsertUser = typeof users.$inferInsert;
export type User = typeof users.$inferSelect;
export type Page = typeof pages.$inferSelect;
export type InsertPage = z.infer<typeof insertPageSchema>;
export type Testimonial = typeof testimonials.$inferSelect;
export type InsertTestimonial = z.infer<typeof insertTestimonialSchema>;
export type FitnessClass = typeof fitnessClasses.$inferSelect;
export type InsertFitnessClass = z.infer<typeof insertFitnessClassSchema>;
export type ClassSchedule = typeof classSchedules.$inferSelect;
export type MembershipPlan = typeof membershipPlans.$inferSelect;
export type InsertMembershipPlan = z.infer<typeof insertMembershipPlanSchema>;
export type Membership = typeof memberships.$inferSelect;
export type Product = typeof products.$inferSelect;
export type InsertProduct = z.infer<typeof insertProductSchema>;
export type ProductCategory = typeof productCategories.$inferSelect;
export type Order = typeof orders.$inferSelect;
export type InsertOrder = z.infer<typeof insertOrderSchema>;
export type OrderItem = typeof orderItems.$inferSelect;
export type Payment = typeof payments.$inferSelect;
export type NewsletterSubscription = typeof newsletterSubscriptions.$inferSelect;
export type InsertNewsletterSubscription = z.infer<typeof insertNewsletterSubscriptionSchema>;
export type ContactSubmission = typeof contactSubmissions.$inferSelect;
export type InsertContactSubmission = z.infer<typeof insertContactSubmissionSchema>;

// Authentication types and schemas
export type Credentials = {
  username?: string;
  email?: string;
  identifier?: string;
  currentPassword?: string;
  password?: string;
  confirmPassword?: string;
  newPassword?: string;
  code?: string;
};

export type SessionPayload = {
  user?: User;
  expiresAt?: Date;
  jwt?: string;
  userId?: string;
};

export type AuthFormState = {
  errors: Partial<Credentials>;
  values: Credentials;
  message?: string;
  success?: boolean;
};

// Email/password authentication schemas
export const signUpSchema = z.object({
  email: z.string().email("Please enter a valid email address"),
  password: z.string().min(6, "Password must be at least 6 characters"),
  confirmPassword: z.string(),
  firstName: z.string().min(1, "First name is required"),
  lastName: z.string().min(1, "Last name is required"),
}).refine((data) => data.password === data.confirmPassword, {
  message: "Passwords don't match",
  path: ["confirmPassword"],
});

export const signInSchema = z.object({
  email: z.string().email("Please enter a valid email address"),
  password: z.string().min(1, "Password is required"),
});

export const forgotPasswordSchema = z.object({
  email: z.string().email("Please enter a valid email address"),
});

export const resetPasswordSchema = z.object({
  password: z.string().min(6, "Password must be at least 6 characters"),
  confirmPassword: z.string(),
  code: z.string().min(1, "Reset code is required"),
}).refine((data) => data.password === data.confirmPassword, {
  message: "Passwords don't match",
  path: ["confirmPassword"],
});

export type SignUpData = z.infer<typeof signUpSchema>;
export type SignInData = z.infer<typeof signInSchema>;
export type ForgotPasswordData = z.infer<typeof forgotPasswordSchema>;
export type ResetPasswordData = z.infer<typeof resetPasswordSchema>;
