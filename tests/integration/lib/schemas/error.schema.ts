import { z } from 'zod';

/** Auth service error (auth.v1 format): { code, reason } */
export const AuthErrorSchema = z.object({
  code: z.number(),
  reason: z.string(),
});

/** Common API error (common/models/error.v1): { code, message } */
export const ApiErrorSchema = z.object({
  code: z.number(),
  message: z.string(),
});

/** OIDC token error response */
export const TokenErrorSchema = z.object({
  error: z.string(),
  error_description: z.string().optional(),
});

/** Clinic service error (error.v2 format) */
export const ClinicErrorSchema = z.object({
  code: z.string().or(z.number()),
  title: z.string().optional(),
  detail: z.string().optional(),
  source: z.record(z.unknown()).optional(),
  metadata: z.record(z.unknown()).optional(),
});
