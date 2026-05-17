# User Documentation — Inception

## What This Project Provides

Inception sets up a fully containerized web stack with the following services:

| Service | What It Does |
|---|---|
| **NGINX** | Serves as the single entry point (HTTPS on port 443 with TLS) |
| **WordPress** | The website — a content management system |
| **MariaDB** | Stores all WordPress data (posts, users, settings) |
| **Redis** | Speeds up WordPress by caching database queries |
| **FTP (vsftpd)** | Upload/download files from the WordPress directory |
| **Adminer** | Web interface to browse and manage the database |
| **Portainer** | Web dashboard to manage Docker containers |
| **Static Site** | A personal portfolio page (separate from WordPress) |

---

## Starting and Stopping

### Start everything

```bash
make
```

This creates data directories, builds all Docker images, and starts all containers.

### Stop without losing data

```bash
make stop       # Pause all containers
make start      # Resume them
```

### Stop and remove containers (data preserved)

```bash
make down
```

### Full cleanup (removes everything including data)

```bash
make fclean
```

### Rebuild from scratch

```bash
make re
```

---

## Accessing the Website

### WordPress

```
https://yaaqoub.42.fr
```

> **Note:** Your browser will show a security warning because the SSL certificate is self-signed. Click **Advanced** → **Proceed** to continue.

### WordPress Admin Panel

```
https://yaaqoub.42.fr/wp-admin
```

Log in with the WordPress admin credentials configured during setup.

### Adminer (Database Management)

```
http://yaaqoub.42.fr:8080
```

Connection details:

| Field | Value |
|---|---|
| System | MySQL |
| Server | `mariadb` |
| Username | Value of `MYSQL_USER` in `.env` |
| Password | Value of `MYSQL_PASSWORD` in `.env` |
| Database | `wordpress` |

### Portainer

```
https://yaaqoub.42.fr:9443
```

Create an admin account on first access.

### Static Portfolio Site

```
http://yaaqoub.42.fr
```

### FTP

Use an FTP client (e.g., FileZilla):

| Field | Value |
|---|---|
| Host | `yaaqoub.42.fr` |
| Port | `21` |
| Username | Value of `FTP_USER` in `.env` |
| Password | Value of `FTP_PASSWORD` in `.env` |
| Mode | Passive (ports 30000–30009) |

---

## Managing Credentials

All configuration is stored in `srcs/.env`:

```
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=<your password>
MYSQL_ROOT_PASSWORD=<your root password>
MYSQL_HOST=mariadb
FTP_USER=ftpuser
FTP_PASSWORD=<your ftp password>
DOMAIN_NAME=yaaqoub.42.fr
```

The `secrets/` directory contains Docker secret files:

| File | Purpose |
|---|---|
| `secrets/credentials.txt` | WordPress and FTP credentials |
| `secrets/db_password.txt` | MariaDB user password |
| `secrets/db_root_password.txt` | MariaDB root password |

> **Important:** Both `srcs/.env` and `secrets/` are listed in `.gitignore` and should **never** be committed to git.

---

## Checking That Services Are Running

### List all containers

```bash
make ps
```

All containers should show status `Up`.

### View live logs

```bash
make logs
```

### Quick health checks

```bash
# Test NGINX / WordPress
curl -k https://yaaqoub.42.fr

# Test MariaDB
docker exec mariadb mysqladmin ping

# Test Redis
docker exec redis redis-cli ping
# Expected: PONG
```

| Check | Expected Result |
|---|---|
| `make ps` | All containers show `Up` |
| `curl -k https://yaaqoub.42.fr` | HTML content from WordPress |
| `docker exec mariadb mysqladmin ping` | `mysqld is alive` |
| `docker exec redis redis-cli ping` | `PONG` |
