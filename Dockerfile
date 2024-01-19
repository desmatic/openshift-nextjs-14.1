# install dependencies only when needed
FROM registry.access.redhat.com/ubi9/nodejs-20:latest AS deps
USER 0
WORKDIR /app

# install dependencies based on the preferred package manager
COPY package.json package-lock.json ./
RUN npm ci

# Rebuild the source code only when needed
FROM registry.access.redhat.com/ubi9/nodejs-20:latest AS builder
USER 0
WORKDIR /app
ENV NEXT_TELEMETRY_DISABLED 1
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# build the source code
RUN npm run build

# production image, copy all the files and run next
FROM registry.access.redhat.com/ubi9/nodejs-20:latest AS runner
USER 0
WORKDIR /app
ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

# install image binaries
RUN dnf install -y jq
RUN dnf clean all

COPY --from=builder /app/app ./app
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

USER 1001
EXPOSE 3000
ENV PORT 3000
CMD ["npm", "run", "start"]
