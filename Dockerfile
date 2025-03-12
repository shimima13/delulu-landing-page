FROM nginx:alpine

COPY index.html /usr/share/nginx/html
COPY assets /usr/share/nginx/html/assets
COPY download /usr/share/nginx/html/download
