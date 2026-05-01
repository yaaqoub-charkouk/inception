FROM debian:bookworm 

RUN apt-get update && apt-get install -y nginx openssl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/sites-available/default

RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx.key \
    -out /etc/ssl/certs/nginx.crt \
    -subj "/C=MA/ST=State/L=City/O=42/OU=1337/CN=localhost"

ENTRYPOINT ["nginx", "-g", "daemon off;"]

# ["bash"] is the debian default command