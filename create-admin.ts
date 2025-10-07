import { getPayload } from 'payload';
import config from './payload.config';
import { hash } from 'bcryptjs';

async function createAdminUser() {
  console.log('Creating admin user...');
  
  try {
    // Initialize Payload
    const payload = await getPayload({ config });
    
    // Check if admin user already exists
    const existingUsers = await payload.find({
      collection: 'users',
      where: {
        email: {
          equals: 'admin@example.com'
        }
      }
    });
    
    if (existingUsers.docs.length > 0) {
      console.log('Admin user already exists');
      return;
    }
    
    // Create admin user
    const adminUser = await payload.create({
      collection: 'users',
      data: {
        email: 'admin@example.com',
        password: 'password123',
        first_name: 'Admin',
        last_name: 'User',
        auth_provider: 'email',
        email_verified: true,
        role: 'admin'
      }
    });
    
    console.log('Admin user created successfully!');
    console.log('Email: admin@example.com');
    console.log('Password: password123');
  } catch (error) {
    console.error('Error creating admin user:', error);
    process.exit(1);
  }
}

createAdminUser();