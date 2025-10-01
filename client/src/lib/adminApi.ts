import { apiRequest } from '@/lib/queryClient';

// Admin API helper
const adminApi = {
  get: async (endpoint: string) => {
    const response = await apiRequest(`/api/admin${endpoint}`, 'GET');
    return response.json();
  },
  
  post: async (endpoint: string, data?: any) => {
    const response = await apiRequest(`/api/admin${endpoint}`, 'POST', data);
    return response.json();
  },
  
  put: async (endpoint: string, data?: any) => {
    const response = await apiRequest(`/api/admin${endpoint}`, 'PUT', data);
    return response.json();
  },
  
  patch: async (endpoint: string, data?: any) => {
    const response = await apiRequest(`/api/admin${endpoint}`, 'PATCH', data);
    return response.json();
  },
  
  delete: async (endpoint: string) => {
    const response = await apiRequest(`/api/admin${endpoint}`, 'DELETE');
    return response.json();
  }
};

export default adminApi;