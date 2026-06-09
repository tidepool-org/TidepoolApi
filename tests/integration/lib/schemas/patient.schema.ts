import { z } from 'zod';

export const PatientSchema = z.object({
  id: z.string(),
  fullName: z.string(),
  birthDate: z.string(),
  email: z.string().optional(),
  mrn: z.string().optional(),
  targetDevices: z.array(z.string()).optional(),
  tags: z.array(z.string()).optional(),
  createdTime: z.string().optional(),
  updatedTime: z.string().optional(),
}).passthrough();

export const PatientTagSchema = z.object({
  id: z.string(),
  name: z.string(),
});
