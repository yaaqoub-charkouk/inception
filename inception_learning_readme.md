*This project has been created as part of the 42 curriculum by
`<your_login>`{=html}.*

# Inception --- Deep Learning & Implementation Plan

Goal: fully understand Docker, containerization, and the NGINX +
WordPress + MariaDB stack, not just finish the project.

Total planned duration: **\~1 month**.

Approach:

theory → experiment → dockerize → debug

Never copy‑paste configs. Always understand what each component does.

------------------------------------------------------------------------

# Global Architecture of the Final Project

Browser │ ▼ NGINX container (HTTPS TLS 1.2/1.3) │ fastcgi ▼ WordPress
container (PHP‑FPM) │ ▼ MariaDB container

Persistent data stored in **Docker volumes**.

------------------------------------------------------------------------

# Week 1 --- Docker Fundamentals

Goal: understand containers and Docker architecture.

Topics to learn:

-   What Docker is
-   Containers vs Virtual Machines
-   Docker architecture (CLI → daemon → container runtime)
-   Images
-   Image layers
-   Dockerfile
-   Containers lifecycle
-   Docker volumes
-   Docker networks
-   Docker CLI

Commands to master:

docker run\
docker build\
docker ps\
docker exec\
docker logs\
docker inspect\
docker volume\
docker network

Practice exercises:

1.  Run a container:

    docker run hello-world

2.  Run an interactive container:

    docker run -it debian bash

3.  Explore container processes:

    ps aux

4.  Inspect containers:

    docker inspect `<container>`{=html}

5.  Remove containers and images.

Goal by end of week:

Understand **how Docker works internally** and how containers are
created.

------------------------------------------------------------------------

# Week 2 --- Understanding the Services (Without Docker)

Goal: understand each service independently.

## MariaDB

Concepts:

-   database server
-   client/server model
-   users
-   permissions
-   databases
-   tables

Practice:

Install MariaDB locally and try:

CREATE DATABASE wordpress; CREATE USER 'wp_user' IDENTIFIED BY
'password'; GRANT ALL PRIVILEGES ON wordpress.\* TO 'wp_user';

Learn how applications connect to databases.

------------------------------------------------------------------------

## WordPress

Understand:

-   WordPress is a **PHP application**
-   It requires:
    -   a web server
    -   PHP runtime
    -   a database

Architecture:

browser → web server → php‑fpm → WordPress → database

Learn:

-   wp-config.php
-   database connection
-   WordPress file structure

------------------------------------------------------------------------

## NGINX

Understand:

-   web server
-   reverse proxy
-   TLS termination
-   FastCGI

Important configuration concepts:

server block\
location\
fastcgi_pass

Example flow:

browser → nginx → php-fpm → WordPress

------------------------------------------------------------------------

# Week 3 --- Dockerizing the Services

Now we start using Docker.

## MariaDB Container

Learn:

-   Dockerfile basics
-   installing packages
-   initialization scripts
-   volumes for data persistence

Goal:

Create a container running MariaDB with a persistent database.

------------------------------------------------------------------------

## WordPress Container

Learn:

-   installing PHP
-   installing php-fpm
-   configuring php-fpm
-   connecting WordPress to MariaDB

Goal:

Run WordPress inside a container.

------------------------------------------------------------------------

## NGINX Container

Learn:

-   nginx configuration
-   reverse proxy
-   fastcgi configuration
-   TLS certificates

Goal:

NGINX serves the website via HTTPS.

------------------------------------------------------------------------

# Week 4 --- Infrastructure Assembly

Combine everything.

Learn:

-   docker-compose
-   container orchestration
-   docker networks
-   docker volumes
-   environment variables
-   secrets
-   Makefile automation

Final structure:

containers:

-   nginx
-   wordpress
-   mariadb

volumes:

-   wordpress database
-   wordpress website files

network:

-   internal docker network

------------------------------------------------------------------------

# Project Rules (Important)

Mandatory requirements:

-   containers built from **Debian or Alpine**
-   each service in **its own container**
-   **no DockerHub images except base OS**
-   **Dockerfiles written manually**
-   **.env file for environment variables**
-   **no passwords in Dockerfiles**
-   **NGINX is the only entrypoint**
-   HTTPS **port 443 only**
-   TLS **1.2 or 1.3**

------------------------------------------------------------------------

# Learning Method

For every topic:

1.  Understand the theory
2.  Run manual experiments
3.  Dockerize the service
4.  Debug problems

Never move to the next step before understanding the previous one.

------------------------------------------------------------------------

# Next Step

Start with:

Learning **what happens internally when running:**

docker run nginx

Understand:

-   image pull
-   container creation
-   filesystem mount
-   namespace isolation
-   cgroups setup
-   process execution

Once understood, move to **image layers and Dockerfile mechanics**.
