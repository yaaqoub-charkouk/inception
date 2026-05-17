FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php \
    php-cli \
    php-mysqli \
    wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

RUN wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php -O index.php
RUN rm -f index.html

EXPOSE 8080

ENTRYPOINT ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
