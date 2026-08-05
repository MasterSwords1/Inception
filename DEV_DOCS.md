# Inception - Developer Documentation

This document provides a technical overview of the Inception infrastructure, detailing the architecture, service configurations, and development practices.

## Architecture Overview

The project is a multi-container Docker application managed by Docker Compose. It is split into two main parts: **Mandatory** and **Bonus**.

### Network Topology

All containers communicate through a custom bridge network called `my_net`. Services use container names as hostnames for internal communication (e.g., WordPress connects to `mariadb:3306`).

### Persistent Storage

Data persistence is handled through local bind mounts. Volumes are mapped from the host's `/home/${USER}/data/` directory to ensure data survives container restarts and recreations.

- `mariadb-data`: `/var/lib/mysql`
- `wp-files`: `/var/www/wordpress`
- `owncast-data`: `/owncast/data` (Bonus only)

## Service Breakdown

### Mandatory Services

#### 1. NGINX
- **Base Image**: `debian:bookworm`
- **Role**: Entry point and Reverse Proxy.
- **Configuration**: Listens on port 443 with TLSv1.3. Forwards PHP requests to the `wordpress` container via FastCGI on port 9000.
- **Security**: Uses self-signed certificates generated during the build/start process.

#### 2. WordPress + PHP-FPM
- **Base Image**: Custom image based on `debian:bookworm`.
- **Role**: Application server.
- **Details**: Runs PHP-FPM to serve the WordPress site. It relies on `mariadb` for the database. **WP-CLI** is installed and used during the container's initialization to automatically download and configure WordPress.
- **Healthcheck**: Uses `cgi-fcgi` to ensure the FPM pool is responsive.

#### 3. MariaDB
- **Base Image**: Custom image based on `debian:bookworm`.
- **Role**: Relational Database Management System.
- **Configuration**: Initialized with a specific database name, admin user, and regular user via environment variables.

### Bonus Services

#### 1. Redis
- **Role**: Object cache for WordPress to improve performance.
- **Details**: WordPress is configured to use Redis as a caching backend.

#### 2. SFTP Server (`openssh-server`)
- **Role**: Secure file management for the WordPress volume.
- **Details**: Provides authenticated access to `/var/www/wordpress` over the SSH protocol (SFTP). Restricted to SFTP-only access for the user.

#### 3. Adminer
- **Role**: Database management web interface.
- **Details**: A lightweight alternative to phpMyAdmin, allowing direct SQL access to MariaDB.

#### 4. Owncast
- **Role**: Self-hosted live streaming server.
- **Port**: Exposed on port 8000.

#### 5. Static Page
- **Role**: Serves a simple static HTML site.
- **Port**: Exposed on port 8081.

## Development Workflow

### Container Initialization
Each service has a `script.sh` (or equivalent) as its `ENTRYPOINT`. These scripts handle:
- Environment variable expansion.
- Initial configuration (e.g., setting up the WordPress database).
- Starting the main process in the foreground.

### Environment Variables
Sensitive data is managed via `.env` files located in `srcs/mandatory/` and `srcs/bonus/`. These are passed to containers using the `env_file` directive in `docker-compose.yml`.

### Best Practices
- **No Pre-built Images**: All images must be built from a base OS image (Debian Bookworm) using custom Dockerfiles.
- **Minimal Layers**: Dockerfiles are optimized to reduce the number of layers and total image size.
- **Process Management**: Containers run only one main service (PID 1) as per Docker best practices.
- **Healthchecks**: Services like WordPress and MariaDB include healthchecks to ensure proper startup sequencing using `depends_on: condition: service_healthy`.

## Modifying the Project

1. **Adding a New Service**:
   - Create a directory in `srcs/bonus/` with a `Dockerfile` and necessary config files.
   - Update `srcs/bonus/docker-compose.yml` to include the new service.
   - Update `Makefile` if new rules are needed.

2. **Changing Configurations**:
   - Configuration files (like `nginx.conf` or `wp-config.php` templates) are located within each service's directory.
   - Rebuild the specific container: `docker compose -f srcs/mandatory/docker-compose.yml build <service_name>`.
