*This project has been created as part of the 42 curriculum by yaaqoub.*

# Inception

## Description

Inception is a system administration project that uses **Docker** and **Docker Compose** to build a complete, secure, multi-service web infrastructure from scratch. Each service runs in its own dedicated container, built from custom Dockerfiles based on **Debian Bookworm**. No pre-built Docker images are used (except for the base OS).

The infrastructure includes:

| Service | Role |
|---|---|
| **NGINX** | Reverse proxy with TLS termination (HTTPS, port 443 only) |
| **WordPress + php-fpm** | Content management system |
| **MariaDB** | Relational database for WordPress |
| **Redis** *(bonus)* | Object cache for WordPress |
| **vsftpd** *(bonus)* | FTP server pointing to WordPress volume |
| **Adminer** *(bonus)* | Web-based database management UI |
| **Portainer** *(bonus)* | Docker container management dashboard |
| **Static Site** *(bonus)* | Personal portfolio (HTML/CSS/JS — no PHP) |

All containers communicate over a custom Docker bridge network. Data persists via Docker named volumes mapped to `~/data/` on the host.

---

### Virtual Machines vs Docker

| Aspect | Virtual Machine | Docker Container |
|---|---|---|
| **Isolation** | Full OS with its own kernel | Shares host kernel, isolated via namespaces and cgroups |
| **Resource usage** | Heavy — GBs of RAM and disk | Lightweight — MBs, shares host resources |
| **Boot time** | Minutes | Seconds |
| **Portability** | Large VM images, OS-specific | Small layered images, portable across systems |
| **Use case** | Full OS simulation, multi-OS support | Microservices, CI/CD, reproducible environments |

Docker containers are **not** virtual machines. They are isolated processes that use Linux kernel features — **namespaces** (PID, network, mount, user) for isolation and **cgroups** for resource control — to run workloads efficiently.

### Secrets vs Environment Variables

| Aspect | Environment Variables | Docker Secrets |
|---|---|---|
| **Storage** | Visible in `docker inspect`, process table | Mounted as files in `/run/secrets/`, tmpfs-backed |
| **Security** | Can leak via logs, child processes | Only accessible inside the container at runtime |
| **Use case** | Non-sensitive config (domain, usernames) | Passwords, API keys, credentials |

Environment variables are convenient but inherently less secure. Docker secrets provide a safer way to pass sensitive data to containers without exposing it in image layers or environment listings.

### Docker Network vs Host Network

| Aspect | Docker Bridge Network | Host Network |
|---|---|---|
| **Isolation** | Containers have their own network namespace | Container shares host's network stack directly |
| **Port mapping** | Explicit port publishing required (`-p`) | All ports exposed on the host |
| **Security** | Better isolation, controlled communication | No network isolation at all |
| **DNS** | Built-in service discovery by container name | No Docker DNS resolution |

This project uses a custom **bridge network** (`inception`) so containers can communicate using service names (e.g., `mariadb`, `wordpress`) while remaining isolated from the host network.

### Docker Volumes vs Bind Mounts

| Aspect | Named Volumes | Bind Mounts |
|---|---|---|
| **Management** | Managed by Docker (`docker volume ls`) | Direct host directory mapping |
| **Portability** | Portable across environments | Depends on host filesystem paths |
| **Performance** | Optimized by Docker storage drivers | Direct filesystem access |
| **Backup** | Via `docker volume` commands | Standard file operations |

This project uses Docker **named volumes** with a local driver configured to store data at specific host paths, combining Docker management with predictable host storage.

---

## Instructions

### Prerequisites

- A Virtual Machine running Debian or Ubuntu
- Docker Engine and Docker Compose installed
- `make` installed
- Domain name configured: `127.0.0.1 yaaqoub.42.fr` in `/etc/hosts`

### Build and Run

```bash
git clone <repository-url>
cd inception

# Build and start all services
make

# Stop services
make down

# Full cleanup (removes containers, images, volumes, data)
make fclean

# Rebuild from scratch
make re
```

### Access Services

| Service | URL |
|---|---|
| WordPress | `https://yaaqoub.42.fr` |
| WordPress Admin | `https://yaaqoub.42.fr/wp-admin` |
| Adminer | `http://yaaqoub.42.fr:8080` |
| Static Site | `http://yaaqoub.42.fr` (port 80) |
| Portainer | `https://yaaqoub.42.fr:9443` |
| FTP | `ftp://yaaqoub.42.fr` (port 21) |

---

## Resources

### Documentation

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [NGINX Configuration](https://nginx.org/en/docs/)
- [WordPress Installation](https://developer.wordpress.org/advanced-administration/before-install/howto-install/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/documentation/)
- [vsftpd Manual](https://security.appspot.com/vsftpd/vsftpd_conf.html)
- [Redis Cache Plugin](https://wordpress.org/plugins/redis-cache/)

### AI Usage

AI tools were used for the following tasks in this project:

- **Debugging**: Diagnosing Docker networking issues and container communication problems.
- **Configuration review**: Verifying NGINX TLS settings and php-fpm configuration.
- **Documentation**: Structuring the README, USER_DOC, and DEV_DOC files.
- **Compliance audit**: Checking Dockerfiles and scripts against subject requirements.

All AI-generated content was reviewed, understood, and validated before inclusion. The architecture, design decisions, and implementation were done independently.
