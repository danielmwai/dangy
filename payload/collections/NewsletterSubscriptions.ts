import { CollectionConfig } from 'payload/types';

export const NewsletterSubscriptions: CollectionConfig = {
  slug: 'newsletter-subscriptions',
  admin: {
    useAsTitle: 'email',
  },
  fields: [
    {
      name: 'email',
      type: 'email',
      required: true,
      unique: true,
    },
    {
      name: 'active',
      type: 'checkbox',
      defaultValue: true,
    },
    {
      name: 'created_at',
      type: 'date',
    },
  ],
};