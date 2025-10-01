import { CollectionConfig } from 'payload/types';

export const ClassSchedules: CollectionConfig = {
  slug: 'class-schedules',
  fields: [
    {
      name: 'class_id',
      type: 'relationship',
      relationTo: 'fitness-classes',
      required: true,
    },
    {
      name: 'day_of_week',
      type: 'number',
      required: true,
      min: 0,
      max: 6,
    },
    {
      name: 'start_time',
      type: 'text',
      required: true,
    },
    {
      name: 'end_time',
      type: 'text',
      required: true,
    },
    {
      name: 'created_at',
      type: 'date',
    },
  ],
};