import type { Express, Request as ExpressRequest } from "express";
import { createServer, type Server } from "http";
import { getStorage } from "./storageInstance";
import { isAuthenticated } from "./googleAuth";
import { mpesaService } from "./services/mpesa";
import { emailService } from "./services/email";
import { 
  insertTestimonialSchema,
  insertFitnessClassSchema,
  insertMembershipPlanSchema,
  insertProductSchema,
  insertNewsletterSubscriptionSchema,
  insertContactSubmissionSchema,
  signUpSchema,
  signInSchema,
  type User
} from "@shared/schema";
import { processSignUp, processSignIn, isEmailAuthenticated } from "./lib/emailAuth";
import { createSessionToken } from "./lib/session";

// Extend the Express Request type to include custom properties
interface CustomRequest extends ExpressRequest {
  emailUser?: User;
  user?: User;
  emailSession?: any;
}

// Admin authentication middleware
const requireAdmin = async (req: CustomRequest, res: any, next: any) => {
  // Check both Google auth and email auth for admin privileges
  const googleUser = req.user;
  const emailUser = req.emailUser;
  
  const user = googleUser || emailUser;
  
  if (!user) {
    return res.status(401).json({ message: "Unauthorized" });
  }
  
  if (user.role !== 'admin') {
    return res.status(403).json({ message: "Admin access required" });
  }
  
  next();
};

export async function registerRoutes(app: Express): Promise<Server> {
  // Email/Password Authentication routes
  app.post('/api/auth/email/signup', async (req, res) => {
    try {
      const user = await processSignUp(req.body);
      
      // Create session token
      const sessionToken = await createSessionToken({
        userId: user.id,
        user,
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
      });

      // Set session cookie
      res.cookie('emailSession', sessionToken, {
        httpOnly: true,
        secure: process.env.NODE_ENV === 'production',
        sameSite: 'lax',
        maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
        path: '/',
      });

      // Return user without password
      const { password, ...userWithoutPassword } = user;
      res.json({ user: userWithoutPassword });
    } catch (error: any) {
      console.error("Email signup error:", error);
      res.status(400).json({ message: error.message || "Failed to sign up" });
    }
  });

  app.post('/api/auth/email/signin', async (req, res) => {
    try {
      const user = await processSignIn(req.body);
      
      // Create session token
      const sessionToken = await createSessionToken({
        userId: user.id,
        user,
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
      });

      // Set session cookie
      res.cookie('emailSession', sessionToken, {
        httpOnly: true,
        secure: process.env.NODE_ENV === 'production',
        sameSite: 'lax',
        maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
        path: '/',
      });

      // Return user without password
      const { password, ...userWithoutPassword } = user;
      res.json({ user: userWithoutPassword });
    } catch (error: any) {
      console.error("Email signin error:", error);
      res.status(400).json({ message: error.message || "Failed to sign in" });
    }
  });

  app.post('/api/auth/email/logout', async (req, res) => {
    try {
      // Clear session cookie
      res.clearCookie('emailSession', {
        httpOnly: true,
        secure: process.env.NODE_ENV === 'production',
        sameSite: 'lax',
        path: '/',
      });

      res.json({ message: "Logged out successfully" });
    } catch (error) {
      console.error("Email logout error:", error);
      res.status(500).json({ message: "Failed to log out" });
    }
  });

  app.get('/api/auth/email/user', isEmailAuthenticated, async (req: any, res) => {
    try {
      // Return user without password
      const { password, ...userWithoutPassword } = req.emailUser;
      res.json(userWithoutPassword);
    } catch (error) {
      console.error("Error fetching email user:", error);
      res.status(500).json({ message: "Failed to fetch user" });
    }
  });

  // Content management routes
  app.get('/api/pages', async (req, res) => {
    try {
      const pages = await getStorage().getPages();
      res.json(pages);
    } catch (error) {
      console.error("Error fetching pages:", error);
      res.status(500).json({ message: "Failed to fetch pages" });
    }
  });

  app.get('/api/pages/:slug', async (req, res) => {
    try {
      const page = await getStorage().getPage(req.params.slug);
      if (!page) {
        return res.status(404).json({ message: "Page not found" });
      }
      res.json(page);
    } catch (error) {
      console.error("Error fetching page:", error);
      res.status(500).json({ message: "Failed to fetch page" });
    }
  });

  // Testimonials
  app.get('/api/testimonials', async (req, res) => {
    try {
      const testimonials = req.query.featured 
        ? await getStorage().getFeaturedTestimonials()
        : await getStorage().getTestimonials();
      res.json(testimonials);
    } catch (error) {
      console.error("Error fetching testimonials:", error);
      res.status(500).json({ message: "Failed to fetch testimonials" });
    }
  });

  app.post('/api/testimonials', async (req, res) => {
    // Allow both Google auth and email auth users to create testimonials
    // But require some form of authentication
    const isAuthenticated = req.isAuthenticated && req.isAuthenticated();
    const isEmailAuthenticated = (req as CustomRequest).emailUser !== undefined;
    
    if (!isAuthenticated && !isEmailAuthenticated) {
      return res.status(401).json({ message: "Unauthorized" });
    }
    
    try {
      const validatedData = insertTestimonialSchema.parse(req.body);
      const testimonial = await getStorage().createTestimonial(validatedData);
      res.json(testimonial);
    } catch (error) {
      console.error("Error creating testimonial:", error);
      res.status(500).json({ message: "Failed to create testimonial" });
    }
  });

  // Fitness classes
  app.get('/api/classes', async (req, res) => {
    try {
      const classes = await getStorage().getFitnessClasses();
      res.json(classes);
    } catch (error) {
      console.error("Error fetching classes:", error);
      res.status(500).json({ message: "Failed to fetch classes" });
    }
  });

  app.get('/api/classes/:id/schedules', async (req, res) => {
    try {
      const schedules = await getStorage().getClassSchedules(req.params.id);
      res.json(schedules);
    } catch (error) {
      console.error("Error fetching class schedules:", error);
      res.status(500).json({ message: "Failed to fetch class schedules" });
    }
  });

  // Membership plans
  app.get('/api/membership-plans', async (req, res) => {
    try {
      const plans = await getStorage().getMembershipPlans();
      res.json(plans);
    } catch (error) {
      console.error("Error fetching membership plans:", error);
      res.status(500).json({ message: "Failed to fetch membership plans" });
    }
  });

  app.get('/api/membership/current', async (req: any, res) => {
    // Check for both Google auth and email auth
    const userId = (req as CustomRequest).user?.id || (req as CustomRequest).emailUser?.id;
    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }
    
    try {
      const membership = await getStorage().getUserMembership(userId);
      res.json(membership);
    } catch (error) {
      console.error("Error fetching user membership:", error);
      res.status(500).json({ message: "Failed to fetch membership" });
    }
  });

  // Products
  app.get('/api/products', async (req, res) => {
    try {
      const products = req.query.featured 
        ? await getStorage().getFeaturedProducts()
        : await getStorage().getProducts();
      res.json(products);
    } catch (error) {
      console.error("Error fetching products:", error);
      res.status(500).json({ message: "Failed to fetch products" });
    }
  });

  app.get('/api/products/:id', async (req, res) => {
    try {
      const product = await getStorage().getProduct(req.params.id);
      if (!product) {
        return res.status(404).json({ message: "Product not found" });
      }
      res.json(product);
    } catch (error) {
      console.error("Error fetching product:", error);
      res.status(500).json({ message: "Failed to fetch product" });
    }
  });

  app.get('/api/categories', async (req, res) => {
    try {
      const categories = await getStorage().getProductCategories();
      res.json(categories);
    } catch (error) {
      console.error("Error fetching categories:", error);
      res.status(500).json({ message: "Failed to fetch categories" });
    }
  });

  // Orders
  app.post('/api/orders', async (req: any, res) => {
    // Check for both Google auth and email auth
    const userId = (req as CustomRequest).user?.id || (req as CustomRequest).emailUser?.id;
    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }
    
    try {
      const { items, shippingAddress, total } = req.body;

      // Create order
      const order = await getStorage().createOrder({
        userId,
        total,
        shippingAddress,
        status: 'pending'
      });

      // Add order items
      for (const item of items) {
        await getStorage().addOrderItem({
          orderId: order.id,
          productId: item.productId,
          quantity: item.quantity,
          price: item.price
        });
      }

      res.json(order);
    } catch (error) {
      console.error("Error creating order:", error);
      res.status(500).json({ message: "Failed to create order" });
    }
  });

  app.get('/api/orders', async (req: any, res) => {
    // Check for both Google auth and email auth
    const userId = (req as CustomRequest).user?.id || (req as CustomRequest).emailUser?.id;
    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }
    
    try {
      const orders = await getStorage().getUserOrders(userId);
      res.json(orders);
    } catch (error) {
      console.error("Error fetching orders:", error);
      res.status(500).json({ message: "Failed to fetch orders" });
    }
  });

  // Payment routes
  app.post('/api/payments/stk-push', async (req, res) => {
    try {
      const { phoneNumber, amount, orderId, membershipPlanId, accountReference } = req.body;

      if (!phoneNumber || !amount || !accountReference) {
        return res.status(400).json({ message: "Missing required fields" });
      }

      // Create payment record
      const payment = await getStorage().createPayment({
        orderId,
        membershipId: membershipPlanId,
        amount,
        phoneNumber,
        method: 'mpesa',
        status: 'pending'
      });

      // Initiate STK push
      const result = await mpesaService.initiateSTKPush({
        phoneNumber,
        amount: parseFloat(amount),
        accountReference: `PAY-${payment.id}`,
        transactionDesc: `Payment for ${accountReference}`
      });

      if (result.success) {
        res.json({
          success: true,
          paymentId: payment.id,
          checkoutRequestId: result.data?.CheckoutRequestID,
          message: "Payment initiated. Please check your phone."
        });
      } else {
        await getStorage().updatePaymentStatus(payment.id, 'failed');
        res.status(400).json(result);
      }
    } catch (error) {
      console.error("Payment initiation error:", error);
      res.status(500).json({ message: "Failed to initiate payment" });
    }
  });

  app.post('/api/payments/mpesa/callback', async (req, res) => {
    try {
      console.log('M-Pesa Callback:', JSON.stringify(req.body, null, 2));
      
      const callbackResult = mpesaService.processCallback(req.body);
      
      if (callbackResult.success) {
        // Find payment by checkout request ID or transaction reference
        // Update payment status and order/membership
        console.log('Payment successful:', callbackResult);
        
        // Here you would typically:
        // 1. Find the payment record
        // 2. Update payment status
        // 3. Update order status or activate membership
        // 4. Send confirmation email
      } else {
        console.log('Payment failed:', callbackResult.resultDesc);
      }
      
      res.json({ ResultCode: 0, ResultDesc: 'Success' });
    } catch (error) {
      console.error("Callback processing error:", error);
      res.status(500).json({ message: "Callback processing failed" });
    }
  });

  app.get('/api/payments/:id/status', async (req, res) => {
    try {
      const payment = await getStorage().getPayment(req.params.id);
      if (!payment) {
        return res.status(404).json({ message: "Payment not found" });
      }
      res.json({ status: payment.status, payment });
    } catch (error) {
      console.error("Error fetching payment status:", error);
      res.status(500).json({ message: "Failed to fetch payment status" });
    }
  });

  // Newsletter subscription
  app.post('/api/newsletter/subscribe', async (req, res) => {
    try {
      const validatedData = insertNewsletterSubscriptionSchema.parse(req.body);
      const subscription = await getStorage().subscribeNewsletter(validatedData);
      
      // Send welcome email
      await emailService.sendEmail({
        to: validatedData.email,
        subject: 'Welcome to FeminaFit Newsletter!',
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h1 style="color: #e91e63;">Welcome to Our Community!</h1>
            <p>Thank you for subscribing to the FeminaFit newsletter.</p>
            <p>You'll receive updates on classes, events, and wellness tips.</p>
            <p>Best regards,<br>The FeminaFit Team</p>
          </div>
        `
      });

      res.json({ message: "Successfully subscribed to newsletter" });
    } catch (error) {
      console.error("Newsletter subscription error:", error);
      res.status(500).json({ message: "Failed to subscribe to newsletter" });
    }
  });

  // Contact form
  app.post('/api/contact', async (req, res) => {
    try {
      const validatedData = insertContactSubmissionSchema.parse(req.body);
      const submission = await getStorage().createContactSubmission(validatedData);
      
      // Send notification email to admin
      await emailService.sendEmail({
        to: 'feminafit59@gmail.com',
        subject: `New Contact Form Submission from ${validatedData.name}`,
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h1>New Contact Form Submission</h1>
            <p><strong>Name:</strong> ${validatedData.name}</p>
            <p><strong>Email:</strong> ${validatedData.email}</p>
            <p><strong>Phone:</strong> ${validatedData.phone || 'Not provided'}</p>
            <p><strong>Message:</strong></p>
            <p>${validatedData.message}</p>
          </div>
        `
      });

      res.json({ message: "Message sent successfully" });
    } catch (error) {
      console.error("Contact submission error:", error);
      res.status(500).json({ message: "Failed to send message" });
    }
  });

  // Admin routes - Require admin privileges
  app.get('/api/admin/users', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const users = await getStorage().getAllUsers();
      res.json(users);
    } catch (error) {
      console.error("Error fetching users:", error);
      res.status(500).json({ message: "Failed to fetch users" });
    }
  });

  app.patch('/api/admin/users/:id', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const { id } = req.params;
      const { role } = req.body;
      
      const updatedUser = await getStorage().updateUserRole(id, role);
      res.json(updatedUser);
    } catch (error) {
      console.error("Error updating user:", error);
      res.status(500).json({ message: "Failed to update user" });
    }
  });

  // Admin fitness classes management
  app.get('/api/admin/classes', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const classes = await getStorage().getAllFitnessClasses();
      res.json(classes);
    } catch (error) {
      console.error("Error fetching fitness classes:", error);
      res.status(500).json({ message: "Failed to fetch fitness classes" });
    }
  });

  app.post('/api/admin/classes', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const newClass = await getStorage().createFitnessClass(req.body);
      res.status(201).json(newClass);
    } catch (error) {
      console.error("Error creating fitness class:", error);
      res.status(500).json({ message: "Failed to create fitness class" });
    }
  });

  app.patch('/api/admin/classes/:id', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const { id } = req.params;
      const updatedClass = await getStorage().updateFitnessClass(id, req.body);
      res.json(updatedClass);
    } catch (error) {
      console.error("Error updating fitness class:", error);
      res.status(500).json({ message: "Failed to update fitness class" });
    }
  });

  app.delete('/api/admin/classes/:id', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const { id } = req.params;
      await getStorage().deleteFitnessClass(id);
      res.json({ message: "Fitness class deleted successfully" });
    } catch (error) {
      console.error("Error deleting fitness class:", error);
      res.status(500).json({ message: "Failed to delete fitness class" });
    }
  });

  // Admin membership plans management
  app.get('/api/admin/membership-plans', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const plans = await getStorage().getAllMembershipPlans();
      res.json(plans);
    } catch (error) {
      console.error("Error fetching membership plans:", error);
      res.status(500).json({ message: "Failed to fetch membership plans" });
    }
  });

  app.post('/api/admin/membership-plans', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const newPlan = await getStorage().createMembershipPlan(req.body);
      res.status(201).json(newPlan);
    } catch (error) {
      console.error("Error creating membership plan:", error);
      res.status(500).json({ message: "Failed to create membership plan" });
    }
  });

  app.patch('/api/admin/membership-plans/:id', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const { id } = req.params;
      const updatedPlan = await getStorage().updateMembershipPlan(id, req.body);
      res.json(updatedPlan);
    } catch (error) {
      console.error("Error updating membership plan:", error);
      res.status(500).json({ message: "Failed to update membership plan" });
    }
  });

  app.delete('/api/admin/membership-plans/:id', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const { id } = req.params;
      await getStorage().deleteMembershipPlan(id);
      res.json({ message: "Membership plan deleted successfully" });
    } catch (error) {
      console.error("Error deleting membership plan:", error);
      res.status(500).json({ message: "Failed to delete membership plan" });
    }
  });

  // Admin products management
  app.get('/api/admin/products', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const products = await getStorage().getAllProducts();
      res.json(products);
    } catch (error) {
      console.error("Error fetching products:", error);
      res.status(500).json({ message: "Failed to fetch products" });
    }
  });

  app.post('/api/admin/products', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const newProduct = await getStorage().createProduct(req.body);
      res.status(201).json(newProduct);
    } catch (error) {
      console.error("Error creating product:", error);
      res.status(500).json({ message: "Failed to create product" });
    }
  });

  app.patch('/api/admin/products/:id', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const { id } = req.params;
      const updatedProduct = await getStorage().updateProduct(id, req.body);
      res.json(updatedProduct);
    } catch (error) {
      console.error("Error updating product:", error);
      res.status(500).json({ message: "Failed to update product" });
    }
  });

  app.delete('/api/admin/products/:id', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const { id } = req.params;
      await getStorage().deleteProduct(id);
      res.json({ message: "Product deleted successfully" });
    } catch (error) {
      console.error("Error deleting product:", error);
      res.status(500).json({ message: "Failed to delete product" });
    }
  });

  // Admin testimonials management
  app.get('/api/admin/testimonials', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const testimonials = await getStorage().getAllTestimonials();
      res.json(testimonials);
    } catch (error) {
      console.error("Error fetching testimonials:", error);
      res.status(500).json({ message: "Failed to fetch testimonials" });
    }
  });

  app.post('/api/admin/testimonials', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const newTestimonial = await getStorage().createTestimonial(req.body);
      res.status(201).json(newTestimonial);
    } catch (error) {
      console.error("Error creating testimonial:", error);
      res.status(500).json({ message: "Failed to create testimonial" });
    }
  });

  app.patch('/api/admin/testimonials/:id', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const { id } = req.params;
      const updatedTestimonial = await getStorage().updateTestimonial(id, req.body);
      res.json(updatedTestimonial);
    } catch (error) {
      console.error("Error updating testimonial:", error);
      res.status(500).json({ message: "Failed to update testimonial" });
    }
  });

  app.delete('/api/admin/testimonials/:id', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const { id } = req.params;
      await getStorage().deleteTestimonial(id);
      res.json({ message: "Testimonial deleted successfully" });
    } catch (error) {
      console.error("Error deleting testimonial:", error);
      res.status(500).json({ message: "Failed to delete testimonial" });
    }
  });

  // Admin pages management
  app.get('/api/admin/pages', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const pages = await getStorage().getAllPages();
      res.json(pages);
    } catch (error) {
      console.error("Error fetching pages:", error);
      res.status(500).json({ message: "Failed to fetch pages" });
    }
  });

  app.post('/api/admin/pages', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const newPage = await getStorage().createPage(req.body);
      res.status(201).json(newPage);
    } catch (error) {
      console.error("Error creating page:", error);
      res.status(500).json({ message: "Failed to create page" });
    }
  });

  app.patch('/api/admin/pages/:id', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const { id } = req.params;
      const updatedPage = await getStorage().updatePage(id, req.body);
      res.json(updatedPage);
    } catch (error) {
      console.error("Error updating page:", error);
      res.status(500).json({ message: "Failed to update page" });
    }
  });

  app.delete('/api/admin/pages/:id', requireAdmin, async (req: CustomRequest, res) => {
    try {
      const { id } = req.params;
      await getStorage().deletePage(id);
      res.json({ message: "Page deleted successfully" });
    } catch (error) {
      console.error("Error deleting page:", error);
      res.status(500).json({ message: "Failed to delete page" });
    }
  });

  const httpServer = createServer(app);
  return httpServer;
}
