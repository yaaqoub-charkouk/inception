#!/bin/bash
 
if [ ! -f "/var/lib/mysql/.initialized" ]
then
    echo "first run "    
    su mysql -s /bin/bash -c "mysqld &"

    until mysqladmin ping --silent; do
        sleep 1
    done

    mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"
    
    envsubst < /init.sql | mysql -u root -p"$MYSQL_ROOT_PASSWORD"

    mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

    touch /var/lib/mysql/.initialized

else
    echo "not first run"
fi

exec su mysql -s /bin/bash -c "mysqld"