#!/bin/bash

cd /var/www/html

if [ ! -f "wp-config.php" ]; then
    cp wp-config-sample.php wp-config.php

    sed -i "s/database_name_here/$MYSQL_DATABASE/" wp-config.php
    sed -i "s/username_here/$MYSQL_USER/" wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/" wp-config.php
    sed -i "s/localhost/$MYSQL_HOST/" wp-config.php

    sed -i "/Happy publishing/i define( 'WP_REDIS_HOST', 'redis' );" wp-config.php

fi

while ! mysqladmin ping -h"$MYSQL_HOST" --silent; do
    sleep 2
done

if ! wp core is-installed --allow-root; then

    wp core install \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root
fi

exec php-fpm8.2 -F

# $MYSQL_HOST tells wordpress where does the database server lives (service name : mariadb)


# Required Commands
# Install WordPress + Admin
# wp core install \
#     --url="$DOMAIN_NAME" \
#     --title="$WP_TITLE" \
#     --admin_user="$WP_ADMIN_USER" \
#     --admin_password="$WP_ADMIN_PASSWORD" \
#     --admin_email="$WP_ADMIN_EMAIL" \
#     --allow-root
# Create a Second User
# wp user create \
#     "$WP_USER" \
#     "$WP_USER_EMAIL" \
#     --user_pass="$WP_USER_PASSWORD" \
#     --role=author \
#     --allow-root
