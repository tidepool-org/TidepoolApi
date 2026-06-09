import { z } from 'zod';

export const UserSchema = z.object({
  userid: z.string(),
  emailVerified: z.boolean(),
  username: z.string().optional(),
  emails: z.array(z.string()).optional(),
  termsAccepted: z.string().optional(),
  roles: z.array(z.string()).optional(),
  createdTime: z.string().optional(),
  modifiedTime: z.string().optional(),
});

export const TokenDataSchema = z.object({
  userid: z.string().optional(),
  isserver: z.boolean().optional(),
});
