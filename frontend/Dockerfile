# Development stage
FROM node:18-alpine AS development

WORKDIR /app

# Install curl for health checks
RUN apk add --no-cache curl

# Copy package files
COPY package*.json ./

# Install ALL dependencies (including dev dependencies for development)
RUN npm install

# Copy source code
COPY . .

# Set environment variables for development
ENV NODE_ENV=development
ENV CHOKIDAR_USEPOLLING=true
ENV HOST=0.0.0.0
ENV PORT=3000
ENV REACT_APP_YOLO_API=http://localhost:5000
ENV REACT_APP_DEPTH_API=http://localhost:5050

EXPOSE 3000

# Health check for development
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# Start development server
CMD ["npm", "start"]

# Build stage (intermediate stage for production)
FROM node:18-alpine AS build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (including dev dependencies needed for build)
RUN npm ci

# Copy source code
COPY . .

# Build arguments for API URLs (can be overridden at build time)
ARG REACT_APP_YOLO_API=http://localhost:5000
ARG REACT_APP_DEPTH_API=http://localhost:5050

# Set environment variables for build
ENV NODE_ENV=production
ENV REACT_APP_YOLO_API=$REACT_APP_YOLO_API
ENV REACT_APP_DEPTH_API=$REACT_APP_DEPTH_API

# Build the application
RUN npm run build

# Production stage
FROM node:18-alpine AS production

WORKDIR /app

# Install curl for health checks
RUN apk add --no-cache curl

# Install serve globally to serve the built app
RUN npm install -g serve

# Copy built application from build stage
COPY --from=build /app/build ./build

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs \
    && adduser -S reactuser -u 1001 -G nodejs \
    && chown -R reactuser:nodejs /app

# Switch to non-root user
USER reactuser

EXPOSE 3000

# Health check for production
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# Serve the built application
CMD ["serve", "-s", "build", "-l", "3000"]