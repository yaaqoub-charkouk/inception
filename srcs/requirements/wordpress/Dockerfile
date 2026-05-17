FROM debian:bookworm


RUN apt-get update && apt-get install -y  php-fpm \
    php-mysql  php-cli  php-curl  php-gd  php-mbstring \
    php-xml  php-zip  php-redis  wget  curl  tar && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


RUN wget https://wordpress.org/wordpress-6.7.2.tar.gz && \
    tar -xzf wordpress-6.7.2.tar.gz && \
    mkdir -p /var/www/html && \
    mv wordpress/* /var/www/html && \
    rm -rf wordpress-6.7.2.tar.gz wordpress

RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

RUN sed -i 's/daemonize = yes/daemonize = no/' /etc/php/8.2/fpm/php-fpm.conf

RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

ENTRYPOINT ["/init.sh"]

