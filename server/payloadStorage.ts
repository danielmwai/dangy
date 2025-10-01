import payload from 'payload';
import { IStorage } from './storage';
import {
  type User,
  type UpsertUser,
  type Page,
  type InsertPage,
  type Testimonial,
  type InsertTestimonial,
  type FitnessClass,
  type InsertFitnessClass,
  type ClassSchedule,
  type MembershipPlan,
  type InsertMembershipPlan,
  type Membership,
  type Product,
  type InsertProduct,
  type ProductCategory,
  type Order,
  type InsertOrder,
  type OrderItem,
  type Payment,
  type NewsletterSubscription,
  type InsertNewsletterSubscription,
  type ContactSubmission,
  type InsertContactSubmission,
} from '@shared/schema';

export class PayloadStorage implements IStorage {
  // User operations (required for auth)
  async getUser(id: string): Promise<User | undefined> {
    try {
      const user = await payload.findByID({
        collection: 'users',
        id: parseInt(id, 10),
      });
      return user as User;
    } catch (error) {
      console.error('Error fetching user:', error);
      return undefined;
    }
  }

  async getUserByEmail(email: string): Promise<User | undefined> {
    try {
      const users = await payload.find({
        collection: 'users',
        where: { email: { equals: email } },
        limit: 1,
      });
      return users.docs[0] as User;
    } catch (error) {
      console.error('Error fetching user by email:', error);
      return undefined;
    }
  }

  async upsertUser(user: UpsertUser): Promise<User> {
    try {
      // If the user already exists, update it; otherwise create a new one
      const existingUser = await this.getUserByEmail(user.email!);
      if (existingUser) {
        const updatedUser = await payload.update({
          collection: 'users',
          id: existingUser.id.toString(),
          data: user,
        });
        return updatedUser as User;
      } else {
        const newUser = await payload.create({
          collection: 'users',
          data: user,
        });
        return newUser as User;
      }
    } catch (error) {
      console.error('Error upserting user:', error);
      throw error;
    }
  }

  async createUserWithEmail(userData: { email: string; password: string; firstName: string; lastName: string }): Promise<User> {
    try {
      const user = await payload.create({
        collection: 'users',
        data: {
          ...userData,
          authProvider: 'email',
          emailVerified: false,
        },
      });
      return user as User;
    } catch (error) {
      console.error('Error creating user with email:', error);
      throw error;
    }
  }

  // Content management
  async getPage(slug: string): Promise<Page | undefined> {
    try {
      const pages = await payload.find({
        collection: 'pages',
        where: { 
          and: [
            { slug: { equals: slug } },
            { published: { equals: true } }
          ]
        },
        limit: 1,
      });
      return pages.docs[0] as Page;
    } catch (error) {
      console.error('Error fetching page:', error);
      return undefined;
    }
  }

  async getPages(): Promise<Page[]> {
    try {
      const pages = await payload.find({
        collection: 'pages',
        where: { published: { equals: true } },
        sort: '-createdAt',
      });
      return pages.docs as Page[];
    } catch (error) {
      console.error('Error fetching pages:', error);
      return [];
    }
  }

  async createPage(page: InsertPage): Promise<Page> {
    try {
      const newPage = await payload.create({
        collection: 'pages',
        data: page,
      });
      return newPage as Page;
    } catch (error) {
      console.error('Error creating page:', error);
      throw error;
    }
  }

  async updatePage(id: string, page: Partial<InsertPage>): Promise<Page | undefined> {
    try {
      const updatedPage = await payload.update({
        collection: 'pages',
        id,
        data: page,
      });
      return updatedPage as Page;
    } catch (error) {
      console.error('Error updating page:', error);
      return undefined;
    }
  }

  // Testimonials
  async getTestimonials(): Promise<Testimonial[]> {
    try {
      const testimonials = await payload.find({
        collection: 'testimonials',
        sort: '-createdAt',
      });
      return testimonials.docs as Testimonial[];
    } catch (error) {
      console.error('Error fetching testimonials:', error);
      return [];
    }
  }

  async getFeaturedTestimonials(): Promise<Testimonial[]> {
    try {
      const testimonials = await payload.find({
        collection: 'testimonials',
        where: { featured: { equals: true } },
        sort: '-createdAt',
      });
      return testimonials.docs as Testimonial[];
    } catch (error) {
      console.error('Error fetching featured testimonials:', error);
      return [];
    }
  }

  async createTestimonial(testimonial: InsertTestimonial): Promise<Testimonial> {
    try {
      const newTestimonial = await payload.create({
        collection: 'testimonials',
        data: testimonial,
      });
      return newTestimonial as Testimonial;
    } catch (error) {
      console.error('Error creating testimonial:', error);
      throw error;
    }
  }

  // Classes
  async getFitnessClasses(): Promise<FitnessClass[]> {
    try {
      const classes = await payload.find({
        collection: 'fitness-classes',
        where: { active: { equals: true } },
      });
      return classes.docs as FitnessClass[];
    } catch (error) {
      console.error('Error fetching fitness classes:', error);
      return [];
    }
  }

  async getFitnessClass(id: string): Promise<FitnessClass | undefined> {
    try {
      const fitnessClass = await payload.findByID({
        collection: 'fitness-classes',
        id: parseInt(id, 10),
      });
      return fitnessClass as FitnessClass;
    } catch (error) {
      console.error('Error fetching fitness class:', error);
      return undefined;
    }
  }

  async getClassSchedules(classId?: string): Promise<ClassSchedule[]> {
    try {
      let whereClause = {};
      if (classId) {
        whereClause = { classId: { equals: parseInt(classId, 10) } };
      }
      
      const schedules = await payload.find({
        collection: 'class-schedules',
        where: whereClause,
      });
      return schedules.docs as ClassSchedule[];
    } catch (error) {
      console.error('Error fetching class schedules:', error);
      return [];
    }
  }

  async createFitnessClass(fitnessClass: InsertFitnessClass): Promise<FitnessClass> {
    try {
      const newClass = await payload.create({
        collection: 'fitness-classes',
        data: fitnessClass,
      });
      return newClass as FitnessClass;
    } catch (error) {
      console.error('Error creating fitness class:', error);
      throw error;
    }
  }

  // Membership plans
  async getMembershipPlans(): Promise<MembershipPlan[]> {
    try {
      const plans = await payload.find({
        collection: 'membership-plans',
        where: { active: { equals: true } },
      });
      return plans.docs as MembershipPlan[];
    } catch (error) {
      console.error('Error fetching membership plans:', error);
      return [];
    }
  }

  async getMembershipPlan(id: string): Promise<MembershipPlan | undefined> {
    try {
      const plan = await payload.findByID({
        collection: 'membership-plans',
        id: parseInt(id, 10),
      });
      return plan as MembershipPlan;
    } catch (error) {
      console.error('Error fetching membership plan:', error);
      return undefined;
    }
  }

  async getUserMembership(userId: string): Promise<Membership | undefined> {
    try {
      const memberships = await payload.find({
        collection: 'memberships',
        where: {
          and: [
            { userId: { equals: parseInt(userId, 10) } },
            { status: { equals: 'active' } }
          ]
        },
        sort: '-createdAt',
        limit: 1,
      });
      return memberships.docs[0] as Membership;
    } catch (error) {
      console.error('Error fetching user membership:', error);
      return undefined;
    }
  }

  async createMembership(membership: any): Promise<Membership> {
    try {
      const newMembership = await payload.create({
        collection: 'memberships',
        data: membership,
      });
      return newMembership as Membership;
    } catch (error) {
      console.error('Error creating membership:', error);
      throw error;
    }
  }

  // Products and e-commerce
  async getProducts(): Promise<Product[]> {
    try {
      const products = await payload.find({
        collection: 'products',
        where: { active: { equals: true } },
      });
      return products.docs as Product[];
    } catch (error) {
      console.error('Error fetching products:', error);
      return [];
    }
  }

  async getProduct(id: string): Promise<Product | undefined> {
    try {
      const product = await payload.findByID({
        collection: 'products',
        id: parseInt(id, 10),
      });
      return product as Product;
    } catch (error) {
      console.error('Error fetching product:', error);
      return undefined;
    }
  }

  async getFeaturedProducts(): Promise<Product[]> {
    try {
      const products = await payload.find({
        collection: 'products',
        where: {
          and: [
            { featured: { equals: true } },
            { active: { equals: true } }
          ]
        },
      });
      return products.docs as Product[];
    } catch (error) {
      console.error('Error fetching featured products:', error);
      return [];
    }
  }

  async getProductCategories(): Promise<ProductCategory[]> {
    try {
      const categories = await payload.find({
        collection: 'product-categories',
        where: { active: { equals: true } },
      });
      return categories.docs as ProductCategory[];
    } catch (error) {
      console.error('Error fetching product categories:', error);
      return [];
    }
  }

  async createProduct(product: InsertProduct): Promise<Product> {
    try {
      const newProduct = await payload.create({
        collection: 'products',
        data: product,
      });
      return newProduct as Product;
    } catch (error) {
      console.error('Error creating product:', error);
      throw error;
    }
  }

  async updateProductStock(id: string, stock: number): Promise<void> {
    try {
      await payload.update({
        collection: 'products',
        id,
        data: { stock },
      });
    } catch (error) {
      console.error('Error updating product stock:', error);
      throw error;
    }
  }

  // Orders
  async createOrder(order: InsertOrder): Promise<Order> {
    try {
      const newOrder = await payload.create({
        collection: 'orders',
        data: order,
      });
      return newOrder as Order;
    } catch (error) {
      console.error('Error creating order:', error);
      throw error;
    }
  }

  async getOrder(id: string): Promise<Order | undefined> {
    try {
      const order = await payload.findByID({
        collection: 'orders',
        id: parseInt(id, 10),
      });
      return order as Order;
    } catch (error) {
      console.error('Error fetching order:', error);
      return undefined;
    }
  }

  async getUserOrders(userId: string): Promise<Order[]> {
    try {
      const orders = await payload.find({
        collection: 'orders',
        where: { userId: { equals: parseInt(userId, 10) } },
        sort: '-createdAt',
      });
      return orders.docs as Order[];
    } catch (error) {
      console.error('Error fetching user orders:', error);
      return [];
    }
  }

  async updateOrderStatus(id: string, status: string): Promise<void> {
    try {
      await payload.update({
        collection: 'orders',
        id,
        data: { status },
      });
    } catch (error) {
      console.error('Error updating order status:', error);
      throw error;
    }
  }

  async addOrderItem(orderItem: any): Promise<OrderItem> {
    try {
      const newOrderItem = await payload.create({
        collection: 'order-items',
        data: orderItem,
      });
      return newOrderItem as OrderItem;
    } catch (error) {
      console.error('Error adding order item:', error);
      throw error;
    }
  }

  // Payments
  async createPayment(payment: any): Promise<Payment> {
    try {
      const newPayment = await payload.create({
        collection: 'payments',
        data: payment,
      });
      return newPayment as Payment;
    } catch (error) {
      console.error('Error creating payment:', error);
      throw error;
    }
  }

  async getPayment(id: string): Promise<Payment | undefined> {
    try {
      const payment = await payload.findByID({
        collection: 'payments',
        id: parseInt(id, 10),
      });
      return payment as Payment;
    } catch (error) {
      console.error('Error fetching payment:', error);
      return undefined;
    }
  }

  async updatePaymentStatus(id: string, status: string, transactionData?: any): Promise<void> {
    try {
      const updateData: any = { status };
      if (transactionData) {
        updateData.mpesaData = transactionData;
        if (transactionData.transactionId) {
          updateData.transactionId = transactionData.transactionId;
        }
      }
      await payload.update({
        collection: 'payments',
        id,
        data: updateData,
      });
    } catch (error) {
      console.error('Error updating payment status:', error);
      throw error;
    }
  }

  // Newsletter
  async subscribeNewsletter(subscription: InsertNewsletterSubscription): Promise<NewsletterSubscription> {
    try {
      const [newSubscription] = await payload.find({
        collection: 'newsletter-subscriptions',
        where: { email: { equals: subscription.email } },
        limit: 1,
      });
      
      if (newSubscription) {
        // Update existing subscription
        return await payload.update({
          collection: 'newsletter-subscriptions',
          id: newSubscription.id.toString(),
          data: { active: true },
        }) as NewsletterSubscription;
      } else {
        // Create new subscription
        return await payload.create({
          collection: 'newsletter-subscriptions',
          data: subscription,
        }) as NewsletterSubscription;
      }
    } catch (error) {
      console.error('Error subscribing to newsletter:', error);
      throw error;
    }
  }

  async getNewsletterSubscriptions(): Promise<NewsletterSubscription[]> {
    try {
      const subscriptions = await payload.find({
        collection: 'newsletter-subscriptions',
        where: { active: { equals: true } },
      });
      return subscriptions.docs as NewsletterSubscription[];
    } catch (error) {
      console.error('Error fetching newsletter subscriptions:', error);
      return [];
    }
  }

  // Contact
  async createContactSubmission(submission: InsertContactSubmission): Promise<ContactSubmission> {
    try {
      const newSubmission = await payload.create({
        collection: 'contact-submissions',
        data: submission,
      });
      return newSubmission as ContactSubmission;
    } catch (error) {
      console.error('Error creating contact submission:', error);
      throw error;
    }
  }

  // Admin methods
  async getAllUsers(): Promise<User[]> {
    try {
      const users = await payload.find({
        collection: 'users',
      });
      return users.docs as User[];
    } catch (error) {
      console.error('Error fetching all users:', error);
      return [];
    }
  }

  async updateUserRole(userId: string, role: string): Promise<User | undefined> {
    try {
      const updatedUser = await payload.update({
        collection: 'users',
        id: userId,
        data: { role },
      });
      return updatedUser as User;
    } catch (error) {
      console.error('Error updating user role:', error);
      return undefined;
    }
  }

  async getAllFitnessClasses(): Promise<FitnessClass[]> {
    try {
      const classes = await payload.find({
        collection: 'fitness-classes',
      });
      return classes.docs as FitnessClass[];
    } catch (error) {
      console.error('Error fetching all fitness classes:', error);
      return [];
    }
  }

  async updateFitnessClass(id: string, updates: Partial<InsertFitnessClass>): Promise<FitnessClass | undefined> {
    try {
      const updatedClass = await payload.update({
        collection: 'fitness-classes',
        id,
        data: updates,
      });
      return updatedClass as FitnessClass;
    } catch (error) {
      console.error('Error updating fitness class:', error);
      return undefined;
    }
  }

  async deleteFitnessClass(id: string): Promise<void> {
    try {
      await payload.delete({
        collection: 'fitness-classes',
        id,
      });
    } catch (error) {
      console.error('Error deleting fitness class:', error);
      throw error;
    }
  }

  async getAllMembershipPlans(): Promise<MembershipPlan[]> {
    try {
      const plans = await payload.find({
        collection: 'membership-plans',
      });
      return plans.docs as MembershipPlan[];
    } catch (error) {
      console.error('Error fetching all membership plans:', error);
      return [];
    }
  }

  async updateMembershipPlan(id: string, updates: Partial<InsertMembershipPlan>): Promise<MembershipPlan | undefined> {
    try {
      const updatedPlan = await payload.update({
        collection: 'membership-plans',
        id,
        data: updates,
      });
      return updatedPlan as MembershipPlan;
    } catch (error) {
      console.error('Error updating membership plan:', error);
      return undefined;
    }
  }

  async deleteMembershipPlan(id: string): Promise<void> {
    try {
      await payload.delete({
        collection: 'membership-plans',
        id,
      });
    } catch (error) {
      console.error('Error deleting membership plan:', error);
      throw error;
    }
  }

  async getAllProducts(): Promise<Product[]> {
    try {
      const products = await payload.find({
        collection: 'products',
      });
      return products.docs as Product[];
    } catch (error) {
      console.error('Error fetching all products:', error);
      return [];
    }
  }

  async updateProduct(id: string, updates: Partial<InsertProduct>): Promise<Product | undefined> {
    try {
      const updatedProduct = await payload.update({
        collection: 'products',
        id,
        data: updates,
      });
      return updatedProduct as Product;
    } catch (error) {
      console.error('Error updating product:', error);
      return undefined;
    }
  }

  async deleteProduct(id: string): Promise<void> {
    try {
      await payload.delete({
        collection: 'products',
        id,
      });
    } catch (error) {
      console.error('Error deleting product:', error);
      throw error;
    }
  }

  async getAllTestimonials(): Promise<Testimonial[]> {
    try {
      const testimonials = await payload.find({
        collection: 'testimonials',
      });
      return testimonials.docs as Testimonial[];
    } catch (error) {
      console.error('Error fetching all testimonials:', error);
      return [];
    }
  }

  async updateTestimonial(id: string, updates: Partial<InsertTestimonial>): Promise<Testimonial | undefined> {
    try {
      const updatedTestimonial = await payload.update({
        collection: 'testimonials',
        id,
        data: updates,
      });
      return updatedTestimonial as Testimonial;
    } catch (error) {
      console.error('Error updating testimonial:', error);
      return undefined;
    }
  }

  async deleteTestimonial(id: string): Promise<void> {
    try {
      await payload.delete({
        collection: 'testimonials',
        id,
      });
    } catch (error) {
      console.error('Error deleting testimonial:', error);
      throw error;
    }
  }

  async getAllPages(): Promise<Page[]> {
    try {
      const pages = await payload.find({
        collection: 'pages',
      });
      return pages.docs as Page[];
    } catch (error) {
      console.error('Error fetching all pages:', error);
      return [];
    }
  }

  async deletePage(id: string): Promise<void> {
    try {
      await payload.delete({
        collection: 'pages',
        id,
      });
    } catch (error) {
      console.error('Error deleting page:', error);
      throw error;
    }
  }

  async getContactSubmissions(): Promise<ContactSubmission[]> {
    try {
      const submissions = await payload.find({
        collection: 'contact-submissions',
        sort: '-createdAt',
      });
      return submissions.docs as ContactSubmission[];
    } catch (error) {
      console.error('Error fetching contact submissions:', error);
      return [];
    }
  }
}