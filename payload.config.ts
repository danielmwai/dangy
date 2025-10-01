import { postgresAdapter } from '@payloadcms/db-postgres';
import { lexicalEditor } from '@payloadcms/richtext-lexical';
import { buildConfig } from 'payload';
import { Users } from './payload/collections/Users';
import { Pages } from './payload/collections/Pages';
import { Products } from './payload/collections/Products';
import { ProductCategories } from './payload/collections/ProductCategories';
import { FitnessClasses } from './payload/collections/FitnessClasses';
import { ClassSchedules } from './payload/collections/ClassSchedules';
import { MembershipPlans } from './payload/collections/MembershipPlans';
import { Testimonials } from './payload/collections/Testimonials';
import { Memberships } from './payload/collections/Memberships';
import { Orders } from './payload/collections/Orders';
import { OrderItems } from './payload/collections/OrderItems';
import { Payments } from './payload/collections/Payments';
import { NewsletterSubscriptions } from './payload/collections/NewsletterSubscriptions';
import { ContactSubmissions } from './payload/collections/ContactSubmissions';
import dotenv from 'dotenv';

dotenv.config();

export default buildConfig({
  secret: process.env.PAYLOAD_SECRET || 'default-dev-secret',
  admin: {
    user: Users.slug,
    importMap: {
      baseDir: process.cwd(),
    },
  },
  collections: [
    {
      ...Users,
      tableName: 'users', // Map to existing table
      access: {
        read: () => true, // Allow public read access to users
        // Only admin can create, update, delete
      }
    },
    {
      ...Pages,
      tableName: 'pages', // Map to existing table
      access: {
        read: () => true, // Allow public read access to pages
        // Only admin can create, update, delete
      }
    },
    {
      ...Products,
      tableName: 'products', // Map to existing table
      access: {
        read: () => true, // Allow public read access to products
        // Only admin can create, update, delete
      }
    },
    {
      ...ProductCategories,
      tableName: 'product_categories', // Map to existing table
      access: {
        read: () => true, // Allow public read access to categories
        // Only admin can create, update, delete
      }
    },
    {
      ...FitnessClasses,
      tableName: 'fitness_classes', // Map to existing table
      access: {
        read: () => true, // Allow public read access to fitness classes
        // Only admin can create, update, delete
      }
    },
    {
      ...ClassSchedules,
      tableName: 'class_schedules', // Map to existing table
      access: {
        read: () => true, // Allow public read access to class schedules
        // Only admin can create, update, delete
      }
    },
    {
      ...MembershipPlans,
      tableName: 'membership_plans', // Map to existing table
      access: {
        read: () => true, // Allow public read access to membership plans
        // Only admin can create, update, delete
      }
    },
    {
      ...Testimonials,
      tableName: 'testimonials', // Map to existing table
      access: {
        read: () => true, // Allow public read access to testimonials
        // Only admin can create, update, delete
      }
    },
    {
      ...Memberships,
      tableName: 'memberships', // Map to existing table
      access: {
        read: ({ req: { user } }) => Boolean(user), // Only logged-in users can read their memberships
        // Only admin can create, update, delete
      }
    },
    {
      ...Orders,
      tableName: 'orders', // Map to existing table
      access: {
        read: ({ req: { user } }) => Boolean(user), // Only logged-in users can read their orders
        // Only admin can create, update, delete
      }
    },
    {
      ...OrderItems,
      tableName: 'order_items', // Map to existing table
      access: {
        read: ({ req: { user } }) => Boolean(user), // Only logged-in users can read order items
        // Only admin can create, update, delete
      }
    },
    {
      ...Payments,
      tableName: 'payments', // Map to existing table
      access: {
        read: ({ req: { user } }) => Boolean(user), // Only logged-in users can read payment info
        // Only admin can create, update, delete
      }
    },
    {
      ...NewsletterSubscriptions,
      tableName: 'newsletter_subscriptions', // Map to existing table
      access: {
        read: () => true, // Allow public read access to newsletter subscriptions
        // Only admin can create, update, delete
      }
    },
    {
      ...ContactSubmissions,
      tableName: 'contact_submissions', // Map to existing table
      access: {
        read: ({ req: { user } }) => user?.role === 'admin', // Only admin can read contact submissions
        create: () => true, // Allow public to submit contact forms
        // Only admin can update, delete
      }
    }
  ],
  access: {
    // Global access control - admin only for everything by default
    admin: ({ req }) => req.user?.role === 'admin',
  },
  editor: lexicalEditor(),
  db: postgresAdapter({
    pool: {
      connectionString: process.env.DATABASE_URL || 'postgresql://anzwa:anzwa@localhost:5432/feminafitgym',
    },
  }),
  typescript: {
    outputFile: './payload-types.ts',
  },
  onInit: async (payload) => {
    // Add any initialization code here
    await payload.logger.info(`Payload Admin URL: ${payload.getAdminURL()}`);
  },
});