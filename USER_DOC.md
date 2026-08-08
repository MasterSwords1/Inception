# Inception - User & Administrator Documentation (`USER_DOC.md`)

Welcome to the **Inception** project user documentation. This guide provides clear, step-by-step instructions for end users and system administrators to manage, access, and monitor the infrastructure stack.

---

## 1. Services Provided by the Stack

The infrastructure consists of isolated microservices running inside dedicated Docker containers:

### 🧩 Mandatory Services
- **NGINX Reverse Proxy**: The sole HTTPS entrypoint listening on port 443, secured with TLSv1.2 and TLSv1.3 encryption protocols.
- **WordPress Application + PHP-FPM**: Web content management system powered by PHP 8.2-FPM and initialized automatically using WP-CLI.
- **MariaDB Database**: Relational database engine storing all WordPress content, configuration, and user accounts.

### 🌟 Bonus Services
- **Redis Cache**: High-performance in-memory object caching backend for WordPress.
- **SFTP Server (`openssh-server`)**: Secure file transfer access restricted to the WordPress uploads directory.
- **Adminer**: Web-based database management interface for direct SQL administration.
- **Static Website**: Fast showcase landing page built without PHP (HTML5/CSS3).
- **Owncast**: Self-hosted live video streaming server.

---

## 2. Starting and Stopping the Project

All operational lifecycle commands are managed through the root [`Makefile`](file:///home/abderahmanriyad15/Inception/Makefile).

### Starting Services
- **Mandatory Stack**:
  ```bash
  make all
  ```
  *(Creates host directories `/home/${USER}/data/` and builds/starts NGINX, WordPress, and MariaDB containers)*

- **Bonus Stack**:
  ```bash
  make bonus
  ```
  *(Launches all mandatory services plus Redis, SFTP, Adminer, Static Site, and Owncast)*

### Stopping Services
- **Stop Containers** (Preserves volumes and data):
  ```bash
  make down
  ```

- **Remove Images and Containers**:
  ```bash
  make clean
  ```

- **Full Reset & Cleanup** (Removes containers, images, volumes, networks, and host data folders):
  ```bash
  make fclean
  ```

- **Complete Rebuild**:
  ```bash
  make re
  ```

---

## 3. Accessing the Website & Administration Panels

### Prerequisites & Host Configuration
Ensure your local host domain is mapped in `/etc/hosts`:
```bash
127.0.0.1  ariyad.42.fr
```

### Access URLs
| Service | Access URL | Description |
| :--- | :--- | :--- |
| **Main WordPress Site** | `https://ariyad.42.fr` | Public WordPress site landing page. |
| **WordPress Admin Panel** | `https://ariyad.42.fr/wp-admin` | Site dashboard (Log in with configured WP admin credentials). |
| **Adminer DB Interface** | `https://ariyad.42.fr/adminer` | Lightweight database management web GUI. |
| **Static Showcase Site** | `https://ariyad.42.fr:8081` | Static HTML landing page. |
| **Owncast Streaming** | `https://ariyad.42.fr:8000` | Live streaming server interface. |
| **SFTP File Access** | `sftp://ariyad.42.fr:22` | SFTP access to `/var/www/wordpress`. |

> [!NOTE]
> **TLS Certificate Warning**: Because NGINX uses a self-signed TLS certificate generated for local testing, your browser will display a security warning (e.g. `NET::ERR_CERT_AUTHORITY_INVALID`). Click **Advanced** and select **Proceed to ariyad.42.fr (unsafe)** to open the website.

---

## 4. Locating and Managing Credentials

### Environment Files
Sensitive variables and configuration parameters are stored in `.env` files located inside the `srcs/` folder:
- Mandatory Environment File: `srcs/mandatory/.env`
- Bonus Environment File: `srcs/bonus/.env`

### Managed Credentials
1. **MariaDB Database Credentials**:
   - `MYSQL_ROOT_PASSWORD`: Master root password for database setup.
   - `MYSQL_DATABASE`: Name of the WordPress database (e.g. `wordpress_db`).
   - `MYSQL_USER`: Regular database username.
   - `MYSQL_PASSWORD`: Password for the regular database user.

2. **WordPress User Accounts**:
   - **Administrator Account**: Set via `WP_ADMIN_USER` and `WP_ADMIN_PASSWORD`.
     > [!IMPORTANT]
     > Subject Rule: Administrator username must **NEVER** contain `admin`, `Admin`, `administrator`, or `Administrator`.
   - **Author/Regular Account**: Set via `WP_USER` and `WP_USER_PASSWORD`.

3. **SFTP Credentials**:
   - `FTP_USER` and `FTP_PASSWORD` for remote SFTP authentication.

---

## 5. Checking Service Health & Status

### Checking Running Containers
Run the Makefile status target to verify all containers are active:
```bash
# For Mandatory containers
make stats

# For Bonus containers
make bonus_stats
```

Alternatively, use native Docker Compose commands:
```bash
docker compose -f srcs/mandatory/docker-compose.yml ps
```

### Viewing Container Logs
To inspect real-time application logs or troubleshoot startup errors:
```bash
make log          # Shows recent mandatory logs
make bonus_log    # Shows recent bonus logs
```

### Testing Endpoint Connectivity
Verify NGINX HTTPS response directly from the command line:
```bash
curl -kI https://ariyad.42.fr
```
*Expected output includes HTTP status `HTTP/1.1 200 OK` or `HTTP/2 200` with valid headers.*
