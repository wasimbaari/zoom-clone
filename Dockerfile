# ==========================================
# Stage 1: Install Dependencies
# ==========================================
FROM node:20-alpine AS deps

# 🔴 Security update for Alpine packages
RUN apk update && apk upgrade && apk add --no-cache libc6-compat

WORKDIR /app

COPY package.json package-lock.json* ./

RUN npm ci


# ==========================================
# Stage 2: Build the Application
# ==========================================
FROM node:20-alpine AS builder

# 🔴 Security update again for this stage
RUN apk update && apk upgrade

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY . .

ENV NEXT_TELEMETRY_DISABLED=1

RUN npm run build


# ==========================================
# Stage 3: Production Runner
# ==========================================
FROM node:20-alpine AS runner

# 🔴 Security update again
RUN apk update && apk upgrade

WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

RUN mkdir .next
RUN chown nextjs:nodejs .next

COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["node", "server.js"]