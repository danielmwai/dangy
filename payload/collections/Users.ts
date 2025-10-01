import { CollectionConfig } from 'payload/types';

export const Users: CollectionConfig = {
  slug: 'users',
  auth: true,
  admin: {
    useAsTitle: 'email',
  },
  fields: [
    {
      name: 'first_name',
      type: 'text',
      required: true,
    },
    {
      name: 'last_name',
      type: 'text',
      required: true,
    },
    {
      name: 'profile_image_url',
      type: 'text',
    },
    {
      name: 'auth_provider',
      type: 'select',
      defaultValue: 'email',
      options: [
        {
          label: 'Email',
          value: 'email',
        },
        {
          label: 'Google',
          value: 'google',
        },
        {
          label: 'Replit',
          value: 'replit',
        },
      ],
    },
    {
      name: 'email_verified',
      type: 'checkbox',
      defaultValue: false,
    },
    {
      name: 'role',
      type: 'select',
      defaultValue: 'user',
      options: [
        {
          label: 'User',
          value: 'user',
        },
        {
          label: 'Admin',
          value: 'admin',
        },
      ],
    },
    {
      name: 'created_at',
      type: 'date',
    },
    {
      name: 'updated_at',
      type: 'date',
    },
  ],
};