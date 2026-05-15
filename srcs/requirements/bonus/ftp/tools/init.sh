#!/bin/bash

useradd -m $FTP_USER

echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

mkdir -p /ftp-data
mkdir -p /var/run/vsftpd/empty

usermod -d /ftp-data $FTP_USER

exec vsftpd /etc/vsftpd.conf
