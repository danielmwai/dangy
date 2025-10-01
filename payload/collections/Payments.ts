import { CollectionConfig } from 'payload/types';

export const Payments: CollectionConfig = {
  slug: 'payments',
  admin: {
    useAsTitle: 'id',
  },
  fields: [
    {
      name: 'order_id',
      type: 'relationship',
      relationTo: 'orders',
    },
    {
      name: 'membership_id',
      type: 'relationship',
      relationTo: 'memberships',
    },
    {
      name: 'amount',
      type: 'number',
      required: true,
      admin: {
        step: 0.01,
      },
    },
    {
      name: 'currency',
      type: 'text',
      defaultValue: 'KES',
    },
    {
      name: 'method',
      type: 'select',
      options: [
        {
          label: 'M-Pesa',
          value: 'mpesa',
        },
        {
          label: 'Card',
          value: 'card',
        },
        {
          label: 'Cash',
          value: 'cash',
        },
      ],
      required: true,
    },
    {
      name: 'status',
      type: 'select',
      defaultValue: 'pending',
      options: [
        {
          label: 'Pending',
          value: 'pending',
        },
        {
          label: 'Completed',
          value: 'completed',
        },
        {
          label: 'Failed',
          value: 'failed',
        },
        {
          label: 'Refunded',
          value: 'refunded',
        },
      ],
      required: true,
    },
    {
      name: 'transaction_id',
      type: 'text',
    },
    {
      name: 'phone_number',
      type: 'text',
    },
    {
      name: 'mpesa_data',
      type: 'json',
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