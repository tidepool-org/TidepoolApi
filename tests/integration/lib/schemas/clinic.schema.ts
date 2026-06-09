import { z } from 'zod';

export const ClinicSchema = z.object({
  id: z.string(),
  name: z.string(),
  shareCode: z.string(),
  address: z.string().optional(),
  city: z.string().optional(),
  postalCode: z.string().optional(),
  state: z.string().optional(),
  country: z.string().optional(),
  clinicType: z.string().optional(),
  clinicSize: z.string().optional(),
  preferredBgUnits: z.enum(['mg/dL', 'mmol/L']),
  timezone: z.string().optional(),
  canMigrate: z.boolean().optional(),
  createdTime: z.string(),
  updatedTime: z.string(),
  tier: z.string().optional(),
  tierDescription: z.string().optional(),
}).passthrough();

export const ClinicianSchema = z.object({
  id: z.string(),
  email: z.string().optional(),
  name: z.string().optional(),
  roles: z.array(z.string()),
  createdTime: z.string().optional(),
  updatedTime: z.string().optional(),
}).passthrough();
