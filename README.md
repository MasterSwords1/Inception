# Inception

A 42 Network project focused on system administration, virtualization, and Docker. This project involves building a small infrastructure of several services (NGINX, WordPress, MariaDB, and more) using Docker Compose, with each service running in its own dedicated, custom-built container.

## 🏗️ Architecture

The infrastructure is designed to be robust, secure, and easily manageable. It uses a custom bridge network for inter-container communication and local bind mounts for persistent data storage.

### 🧩 Mandatory Part
- **NGINX**: The only entry point (Port 443), configured with TLSv1.2/v1.3.
- **WordPress + PHP-FPM**: The web application, automatically configured via WP-CLI.
- **MariaDB**: The relational database engine for WordPress.

### 🌟 Bonus Part
- **Redis**: Object caching for WordPress to improve performance.
- **SFTP Server**: Secure file access to the WordPress volume over SSH.
- **Adminer**: A lightweight database management interface.
- **Owncast**: A self-hosted live streaming server.
- **Static Site**: A simple, fast landing page.

---

## 🚀 Quick Start

### 1. Prerequisites
Ensure you have **Docker** and **Docker Compose** installed on your host system.

### 2. Configure Host Domain
Map the required domain to your local loopback address in `/etc/hosts`:
```bash
sudo echo "127.0.0.1 your_login.42.fr 42.ariyad.fr" >> /etc/hosts
```

### 3. Setup Environment
Create your `.env` files based on the provided examples:
```bash
cp srcs/mandatory/.env.example srcs/mandatory/.env
cp srcs/bonus/.env.example srcs/bonus/.env
```
*Edit these files with your specific configurations and credentials.*

### 4. Build and Run
Use the `Makefile` to manage the infrastructure:

**Mandatory Part:**
```bash
make all        # Build and start mandatory services
make stats      # Check container status
make log        # View container logs
```

**Bonus Part:**
```bash
make bonus      # Build and start all services including bonuses
make bonus_stats
make bonus_log
```

**Stop Services:**
```bash
make down       # Stop and remove containers
```

---

## 🛠️ Technical Details

- **Base OS**: All custom images are built from `Debian Bookworm`.
- **Networking**: Containers communicate via the `my_net` bridge network using service names as hostnames.
- **Persistence**: Data is stored on the host at `/home/${USER}/data/` to ensure persistence across container lifecycles.
- **Security**: 
    - TLS certificates are generated on-the-fly via OpenSSL CLI.
    - Environment variables are used for all sensitive credentials.
    - Restart policies are set to `on-failure` for stability.

## 📖 Documentation
Detailed information can be found in the following files:
- [User Documentation](USER_DOCS.md) - For setup and operation.
- [Developer Documentation](DEV_DOCS.md) - For architectural and technical deep-dives.

---

## 👤 Author
- **Login**: abderahmanriyad15
- **Project**: Inception @ 42
