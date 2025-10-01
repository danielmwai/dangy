import axios from 'axios';
import FormData from 'form-data';
import fs from 'fs';
import path from 'path';

const STRAPI_URL = 'http://localhost:1337/api';
const STRAPI_TOKEN = process.env.STRAPI_API_TOKEN; // Make sure to set this in your .env file

const api = axios.create({
  baseURL: STRAPI_URL,
  headers: {
    Authorization: `Bearer ${STRAPI_TOKEN}`,
  },
});

async function uploadImage(imageUrl: string, name: string) {
  try {
    const response = await axios.get(imageUrl, { responseType: 'arraybuffer' });
    const buffer = Buffer.from(response.data, 'binary');
    
    const formData = new FormData();
    formData.append('files', buffer, `${name}.jpg`);

    const uploadResponse = await api.post('/upload', formData, {
      headers: formData.getHeaders(),
    });

    return uploadResponse.data[0].id;
  } catch (error) {
    console.error('Error uploading image:', error);
    return null;
  }
}

async function seedHeroSection() {
  console.log('Seeding Hero Section...');
  try {
    const imageId = await uploadImage('https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1920&h=1080', 'hero-background');

    const heroData = {
      data: {
        headline: 'Your space.\nYour Health.\nYour Sisterhood',
        subtitle: 'Finally — a high-end gym designed only for women, like you.',
        background_image: imageId,
      }
    };

    await api.put('/hero-section', heroData);
    console.log('Hero Section seeded successfully.');
  } catch (error) {
    console.error('Error seeding Hero Section:', error.response?.data || error.message);
  }
}

async function main() {
  await seedHeroSection();
}

main().catch(console.error);
