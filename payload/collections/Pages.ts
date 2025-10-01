import { CollectionConfig } from 'payload/types';

export const Pages: CollectionConfig = {
  slug: 'pages',
  admin: {
    useAsTitle: 'title',
  },
  fields: [
    {
      name: 'slug',
      type: 'text',
      required: true,
      unique: true,
    },
    {
      name: 'title',
      type: 'text',
      required: true,
    },
    {
      name: 'content',
      type: 'json',
      required: true,
    },
    {
      name: 'meta_description',
      type: 'text',
    },
    {
      name: 'published',
      type: 'checkbox',
      defaultValue: true,
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