import { z } from 'zod';

export const DataSetSchema = z.object({
  id: z.string().optional(),
  uploadId: z.string(),
  type: z.string().optional(),
  dataSetType: z.string().optional(),
  deviceId: z.string(),
  createdTime: z.string().optional(),
  modifiedTime: z.string().optional(),
}).passthrough();

export const BlobMetadataSchema = z.object({
  id: z.string(),
  userId: z.string(),
  mediaType: z.string(),
  size: z.number(),
  status: z.enum(['created', 'available']),
  createdTime: z.string(),
}).passthrough();
