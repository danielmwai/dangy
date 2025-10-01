import { CollectionConfig } from 'payload/types';

export const OrderItems: CollectionConfig = {
  slug: 'order-items',
  admin: {
    useAsTitle: 'id',
  },
  fields: [
    {
      name: 'order_id',
      type: 'relationship',
      relationTo: 'orders',
      required: true,
    },
    {
      name: 'product_id',
      type: 'relationship',
      relationTo: 'products',
      required: true,
    },
    {
      name: 'quantity',
      type: 'number',
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
  ],
};