FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx

WORKDIR /var/www/html

COPY website/index.html .

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
