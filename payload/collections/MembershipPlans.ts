import { CollectionConfig } from 'payload/types';

export const MembershipPlans: CollectionConfig = {
  slug: 'membership-plans',
  admin: {
    useAsTitle: 'name',
  },
  fields: [
    {
      name: 'name',
      type: 'text',
      required: true,
    },
    {
      name: 'description',
      type: 'text',
      required: true,
    },
    {
      name: 'price',
      type: 'number',
      required: true,
      admin: {
        step: 0.01,
      },
    },
    {
      name: 'duration',
      type: 'number',
      required: true,
    },
    {
      name: 'features',
      type: 'json',
    },
    {
      name: 'popular',
      type: 'checkbox',
      defaultValue: false,
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