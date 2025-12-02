# Stage 1: Build the documentation
FROM python:3.12-slim as builder

WORKDIR /build

# Install dependencies
COPY pyproject.toml README.md mkdocs.yml ./
RUN pip install --no-cache-dir mkdocs-material

# Copy documentation source
COPY docs/ ./docs/

# Build the documentation
RUN mkdocs build

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy built documentation from builder stage
COPY --from=builder /build/site /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
