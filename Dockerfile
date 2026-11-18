# Lightweight Nginx image to serve the static HTML page
FROM nginx:alpine

# Copy the website into Nginx's default web directory
COPY index.html /usr/share/nginx/html/index.html

# Nginx listens on port 80 inside the container
EXPOSE 80

# Run Nginx in the foreground so Docker keeps the container running
CMD ["nginx", "-g", "daemon off;"]
