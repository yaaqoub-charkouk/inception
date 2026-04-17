#!/bin/bash

cd /var/www/html

if [ ! -f "wp-config.php" ]; then
    cp wp-config-sample.php wp-config.php

    sed -i "s/database_name_here/$MYSQL_DATABASE/" wp-config.php
    sed -i "s/username_here/$MYSQL_USER/" wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/" wp-config.php
    sed -i "s/localhost/$MYSQL_HOST/" wp-config.php
fi

exec php-fpm8.2 -F
