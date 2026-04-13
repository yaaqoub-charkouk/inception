FROM debian:bookworm 

RUN apt-get update && apt-get install -y mariadb-server gettext-base
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld 
# mysqld need the /run/mysqld folder to create socket


COPY tools/init.sh /init.sh
COPY tools/init.sql /init.sql

RUN chmod +x /init.sh

ENTRYPOINT ["/init.sh"]

# USER mysql

CMD ["mysqld"]


# mysqld can not run with root 
# mysqld need /run/mysqld to create /run/mysqld/{mysql.sock,pid}
