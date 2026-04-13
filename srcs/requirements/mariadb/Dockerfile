FROM debian:bookworm 

RUN apt-get update && apt-get install -y mariadb-server
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld # mysqld need the /run/mysqld folder to create socket

USER mysql

CMD ["mysqld"]


# mysqld can not run with root 
# mysqld need /run/mysqld to create /run/mysqld/{mysql.sock,pid}
