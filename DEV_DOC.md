# Developer Documentation — Inception

## Setting Up the Environment from Scratch

### Prerequisites

1. **Virtual Machine** running Debian 12 (Bookworm) or Ubuntu 22.04+
2. **Docker Engine** (v24+) and **Docker Compose** (v2+)
3. **make** and **git**

#### Installing Docker on Debian

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian $(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker $USER
```

Log out and back in for the group change to take effect.

### DNS Configuration

```bash
echo "127.0.0.1 yaaqoub.42.fr" | sudo tee -a /etc/hosts
```

### Configuration Files

#### `srcs/.env`

Contains all environment variables passed to the containers:

```env
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=strongpassword
MYSQL_ROOT_PASSWORD=rootpassword
MYSQL_HOST=mariadb
FTP_USER=ftpuser
FTP_PASSWORD=ftppassword
DOMAIN_NAME=localhost
```

> This file is gitignored. Create it manually after cloning.

#### `secrets/`

Contains Docker secret files (also gitignored):

```
secrets/
├── credentials.txt        # WordPress/FTP password
├── db_password.txt         # MariaDB user password
└── db_root_password.txt    # MariaDB root password
```

---

## Building and Launching with Makefile and Docker Compose

### Makefile Targets

| Command | Description |
|---|---|
| `make` / `make all` | Create data directories, build images, start containers |
| `make setup` | Create `~/cursus/data/mariadb` and `~/cursus/data/wordpress` |
| `make build` | Build all Docker images from Dockerfiles |
| `make up` | Start all containers in detached mode |
| `make down` | Stop and remove all containers |
| `make stop` | Stop containers without removing them |
| `make start` | Start previously stopped containers |
| `make logs` | Follow live container logs |
| `make ps` | List running containers and their status |
| `make clean` | Stop containers and prune unused Docker resources |
| `make fclean` | Full cleanup — remove containers, images, volumes, and data |
| `make re` | Full clean rebuild from scratch |

### How the Build Works

```
make
 ├── make setup     → mkdir -p ~/cursus/data/{mariadb,wordpress}
 ├── make build     → docker compose -f srcs/docker-compose.yml build
 └── make up        → docker compose -f srcs/docker-compose.yml up -d
```

Docker Compose reads `srcs/docker-compose.yml` which:
- Loads `srcs/.env` for environment variables
- Builds images from `srcs/requirements/<service>/Dockerfile`
- Creates named volumes, networks, and starts containers

---

## Managing Containers and Volumes

### Container Commands

```bash
# Enter a running container
docker exec -it mariadb bash
docker exec -it wordpress bash
docker exec -it nginx bash

# View container logs
docker logs mariadb
docker logs -f wordpress     # follow mode

# Restart a single service
docker compose -f srcs/docker-compose.yml restart wordpress

# Rebuild a single service (no cache)
docker compose -f srcs/docker-compose.yml build --no-cache wordpress
docker compose -f srcs/docker-compose.yml up -d wordpress

# Inspect a container
docker inspect mariadb
```

### Volume Commands

```bash
# List all volumes
docker volume ls

# Inspect a specific volume
docker volume inspect srcs_mariadb_data
docker volume inspect srcs_wordpress_data

# Check volume disk usage
docker system df -v
```

---

## Data Storage and Persistence

### Where Data Lives

| Volume | Container Mount | Host Path |
|---|---|---|
| `mariadb_data` | `/var/lib/mysql` | `~/cursus/data/mariadb` |
| `wordpress_data` | `/var/www/html` | `~/cursus/data/wordpress` |

Both volumes are Docker named volumes configured with `driver: local`, `type: none`, and `o: bind` — this maps them to specific host directories while keeping them manageable via Docker.

### What Persists

- **MariaDB**: All databases, tables, user accounts, `.initialized` flag
- **WordPress**: Themes, plugins, uploads, media, `wp-config.php`

### What Is Lost on `make fclean`

- All container state and images (rebuilt on next `make`)
- All volume data (databases, WordPress files)
- The `~/cursus/data/` directory entirely

### Initialization Logic

- **MariaDB** (`tools/init.sh`): On first run, starts mysqld, sets root password, creates database and user, then touches `.initialized` flag. On subsequent runs, skips initialization and starts mysqld directly.
- **WordPress** (`tools/init.sh`): On first run, copies `wp-config-sample.php`, substitutes database credentials, and configures Redis host.

---

## Project Structure

```
inception/
├── Makefile                              # Build & lifecycle management
├── README.md                             # Project description & comparisons
├── USER_DOC.md                           # End-user documentation
├── DEV_DOC.md                            # This file
├── .gitignore                            # Ignores secrets/, srcs/.env, data/
├── secrets/                              # Docker secrets (gitignored)
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
    ├── .env                              # Environment variables (gitignored)
    ├── docker-compose.yml                # Service orchestration
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   └── tools/
        │       ├── init.sh               # DB init script
        │       └── init.sql              # SQL template
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/nginx.conf           # TLS + reverse proxy config
        ├── wordpress/
        │   ├── Dockerfile
        │   └── tools/init.sh             # WP config + setup
        └── bonus/
            ├── redis/Dockerfile
            ├── ftp/
            │   ├── Dockerfile
            │   ├── conf/vsftpd.conf
            │   └── tools/init.sh
            ├── adminer/Dockerfile
            ├── static-site/
            │   ├── Dockerfile
            │   └── website/index.html
            └── portainer/Dockerfile
```

## Network Architecture

```
Host / Internet
    │
    ├── :443  ──→ NGINX (TLS) ──→ WordPress:9000 (php-fpm)
    │                           └→ wordpress_data volume (static files)
    ├── :80   ──→ Static Site (nginx)
    ├── :8080 ──→ Adminer ──→ MariaDB:3306
    ├── :9443 ──→ Portainer
    └── :21   ──→ FTP ──→ wordpress_data volume

Internal Docker network (inception bridge):
    WordPress ←──→ MariaDB:3306
    WordPress ←──→ Redis:6379
```

NGINX is the **only external entrypoint** for the main infrastructure (port 443). Bonus services expose their own ports for additional functionality.
