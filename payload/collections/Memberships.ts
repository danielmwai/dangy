import { CollectionConfig } from 'payload/types';

export const Memberships: CollectionConfig = {
  slug: 'memberships',
  admin: {
    useAsTitle: 'id',
  },
  fields: [
    {
      name: 'user_id',
      type: 'relationship',
      relationTo: 'users',
      required: true,
    },
    {
      name: 'plan_id',
      type: 'relationship',
      relationTo: 'membership-plans',
      required: true,
    },
    {
      name: 'start_date',
      type: 'date',
      required: true,
    },
    {
      name: 'end_date',
      type: 'date',
      required: true,
    },
    {
      name: 'status',
      type: 'select',
      defaultValue: 'active',
      options: [
        {
          label: 'Active',
          value: 'active',
        },
        {
          label: 'Expired',
          value: 'expired',
        },
        {
          label: 'Cancelled',
          value: 'cancelled',
        },
      ],
      required: true,
    },
    {
      name: 'created_at',
      type: 'date',
    },
  ],
};