# Build stage
FROM squidfunk/mkdocs-material:latest AS build

WORKDIR /build

COPY . .
RUN mkdocs build --clean

# Production stage
FROM nginx:alpine

COPY --from=build /build/site /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
