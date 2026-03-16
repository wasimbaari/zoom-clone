# ==========================================
# Stage 1: Install Dependencies
# ==========================================
FROM node:18-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Copy package management files
COPY package.json package-lock.json* ./

# Install dependencies strictly from the lockfile for consistent builds
RUN npm ci

# ==========================================
# Stage 2: Build the Application
# ==========================================
FROM node:18-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Next.js telemetry is annoying in CI/CD, turn it off
ENV NEXT_TELEMETRY_DISABLED 1

# Build the Next.js app
RUN npm run build

# ==========================================
# Stage 3: Production Runner
# ==========================================
FROM node:18-alpine AS runner
WORKDIR /app

ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

# Run as a non-root user for security
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Set the correct permission for prerender cache
RUN mkdir .next
RUN chown nextjs:nodejs .next

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
# NOTE: Ensure `output: 'standalone'` is set in next.config.js!
COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

CMD ["node", "server.js"]