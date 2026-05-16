FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php \
    php-cli \
    php-mysqli \
    wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
    
WORKDIR /var/www/html

RUN wget https://www.adminer.org/latest.php -O index.php
RUN rm -f index.html

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
