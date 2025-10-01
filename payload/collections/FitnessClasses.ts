import { CollectionConfig } from 'payload/types';

export const FitnessClasses: CollectionConfig = {
  slug: 'fitness-classes',
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
      name: 'duration',
      type: 'number',
      required: true,
    },
    {
      name: 'level',
      type: 'select',
      required: true,
      options: [
        {
          label: 'Beginner',
          value: 'beginner',
        },
        {
          label: 'Intermediate',
          value: 'intermediate',
        },
        {
          label: 'Advanced',
          value: 'advanced',
        },
      ],
    },
    {
      name: 'instructor',
      type: 'text',
    },
    {
      name: 'max_capacity',
      type: 'number',
      defaultValue: 20,
    },
    {
      name: 'image_url',
      type: 'text',
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