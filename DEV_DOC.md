# Inception - Developer Documentation (`DEV_DOC.md`)

This technical document details the internal architecture, build pipelines, service configuration, persistent volume mapping, and container management workflows for developers working on the **Inception** infrastructure.

---

## 1. Setting Up the Environment from Scratch

### System Prerequisites
Developers must use a Linux Virtual Machine (e.g. Debian 12 / Ubuntu 22.04 LTS) equipped with:
- **Docker Engine**: Version 24.0 or higher.
- **Docker Compose**: Plugin version 2.20 or higher.
- **GNU Make**: Version 4.3 or higher.
- **OpenSSL**: For certificate generation inside NGINX build routines.

### Repository Directory Structure
```text
Inception/
├── Makefile                          # Root automation script
├── README.md                         # Main subject documentation
├── USER_DOC.md                       # User & Administrator guide
├── DEV_DOC.md                        # Developer architecture guide
└── srcs/
    ├── mandatory/
    │   ├── docker-compose.yml        # Mandatory multi-container composition
    │   ├── .env.example              # Mandatory environment template
    │   ├── nginx/                    # Custom NGINX Dockerfile & configs
    │   ├── wordpress/                # Custom WordPress + PHP-FPM Dockerfile & scripts
    │   └── mariadb/                  # Custom MariaDB Dockerfile & scripts
    └── bonus/
        ├── docker-compose.yml        # Bonus multi-container composition
        ├── .env.example              # Bonus environment template
        ├── redis/                    # Custom Redis Dockerfile & scripts
        ├── sftp-server/              # Custom SFTP Dockerfile & scripts
        ├── adminer/                  # Custom Adminer Dockerfile & scripts
        ├── static-page/              # Custom static website & NGINX setup
        └── owncast/                  # Custom Owncast live streaming setup
```

### Initial Configuration & Secrets Setup
1. **Domain Setup**:
   Map `ariyad.42.fr` to `127.0.0.1` in `/etc/hosts`:
   ```bash
   sudo sh -c 'echo "127.0.0.1 ariyad.42.fr" >> /etc/hosts'
   ```

2. **Environment & Secrets Initialization**:
   Create active `.env` files from templates:
   ```bash
   cp srcs/mandatory/.env.example srcs/mandatory/.env
   cp srcs/bonus/.env.example srcs/bonus/.env
   ```
   Define database passwords, user accounts, and domain parameters. Ensure sensitive credentials are ignored by Git.

---

## 2. Building and Launching the Infrastructure

All build and orchestration workflows are automated through the root [`Makefile`](file:///home/abderahmanriyad15/Inception/Makefile).

### Build Pipeline Execution
- **Build Mandatory Images**:
  ```bash
  make build
  ```
  *Executes `docker compose -f srcs/mandatory/docker-compose.yml build`, compiling custom images from local Dockerfiles based on `debian:bookworm`.*

- **Launch Mandatory Services**:
  ```bash
  make all
  ```
  *Creates required host data folders (`/home/${USER}/data/...`) and starts containers in detached mode (`-d`).*

- **Build & Launch Bonus Stack**:
  ```bash
  make bonus
  ```
  *Launches all services including Redis, SFTP, Adminer, Static Site, and Owncast.*

### Core Subject Rules & Constraints
- **Custom Dockerfiles Only**: Every container is built from a local `Dockerfile`. Pulling ready-made application images (e.g. `wordpress:latest` or `mariadb:latest`) from DockerHub is strictly prohibited.
- **Base OS**: Base images are restricted to `debian:bookworm` or `alpine`.
- **No PID 1 Hacks**: Containers execute their primary service process as PID 1 via `exec` in shell entrypoint scripts. Commands like `tail -f`, `sleep infinity`, or `while true` are forbidden.

---

## 3. Developer Commands for Container & Volume Management

### Container Orchestration Commands
| Task | Shell Command |
| :--- | :--- |
| **Inspect Running Containers** | `docker compose -f srcs/mandatory/docker-compose.yml ps -a` |
| **Stream Live Container Logs** | `docker compose -f srcs/mandatory/docker-compose.yml logs -f` |
| **Execute Shell in Container** | `docker exec -it <container_name> bash` |
| **Check Container Resource Usage** | `docker stats` |
| **Inspect Network Topography** | `docker network inspect my_net` |
| **Inspect Volume Metadata** | `docker volume inspect mariadb-data wp-files` |

### Debugging Entrypoint Scripts
Each service utilizes an initialization script (`script.sh`) invoked as `ENTRYPOINT` in its Dockerfile:
- **NGINX**: Generates self-signed OpenSSL certificates (`/etc/nginx/ssl/nginx.crt`) on initial startup before executing `nginx -g 'daemon off;'`.
- **MariaDB**: Initializes system tables using `mariadb-install-db` and executes SQL initialization commands before launching `mariadbd`.
- **WordPress**: Uses `wp-cli.phar` to download core files, generate `wp-config.php`, run site installation, create secondary user accounts, and execute `php-fpm8.2 -F`.

---

## 4. Storage Architecture & Persistent Data Storage

### Host Path Mapping & Volumes
As required by the 42 subject, data persistence is maintained via Docker **named volumes** that map to host directories under `/home/${USER}/data/`:

| Named Volume Name | Container Mount Point | Host Directory Path | Purpose |
| :--- | :--- | :--- | :--- |
| `mariadb-data` | `/var/lib/mysql` | `/home/ariyad/data/mariadb_data` | Persistent MariaDB SQL tables & logs. |
| `wp-files` | `/var/www/wordpress` | `/home/ariyad/data/wp_data` | Persistent WordPress source files & uploads. |
| `owncast-data` | `/owncast/data` | `/home/ariyad/data/owncast_data` | Owncast media files & configurations. |

### Docker Compose Volume Definition
Named volumes are configured with local driver options in `docker-compose.yml`:
```yaml
volumes:
  mariadb-data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/ariyad/data/mariadb_data

  wp-files:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/ariyad/data/wp_data
```

### Persistence Lifecycle
- **Container Restarts/Stops (`make down`)**: Data remains intact inside `/home/${USER}/data/`. Rebuilding or recreating containers mounts existing data seamlessly.
- **Full Deletion (`make fclean`)**: Host data directories are purged (`sudo rm -rf ${MANDATORY_DATA_DIRS}`) along with Docker volumes and networks, restoring a completely clean system state.
