# Inception - User Documentation

Welcome to the **Inception** project! This guide will help you set up and run a complete system infrastructure using Docker containers.

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

- **Docker**: [Installation Guide](https://docs.docker.com/get-docker/)
- **Docker Compose**: [Installation Guide](https://docs.docker.com/compose/install/)
- **Make**: Usually pre-installed on Linux and macOS.

## Initial Setup

### Domain Name Configuration

The subject requires the website to be accessible via a specific domain (typically `login.42.fr`). To achieve this locally, you must modify your `/etc/hosts` file.

1. Open the file with administrative privileges:
   ```bash
   sudo nano /etc/hosts
   ```
2. Add the following line (replace `your_login` with your actual 42 login):
   ```text
   127.0.0.1  your_login.42.fr
   ```

### Environment Variables

A `.env` file is required for both mandatory and bonus parts. You should see `.env.example` files in `srcs/mandatory/` and `srcs/bonus/`. Create your own `.env` files based on these examples:

```bash
cp srcs/mandatory/.env.example srcs/mandatory/.env
cp srcs/bonus/.env.example srcs/bonus/.env
```
Update the values (usernames, passwords, etc.) inside these files. **Never share your real credentials.**

## Running the Project

The project is managed via a `Makefile` at the root directory.

### Mandatory Part
The mandatory part includes NGINX (with TLS), WordPress (via PHP-FPM), and MariaDB.

- **Build and start services**:
  ```bash
  make all
  ```
- **Check status**:
  ```bash
  make stats
  ```
- **View logs**:
  ```bash
  make log
  ```

### Bonus Part
The bonus part adds services like Redis, FTP, Adminer, a static site, and more.

- **Build and start bonus services**:
  ```bash
  make bonus
  ```
- **Check status**:
  ```bash
  make bonus_stats
  ```
- **View logs**:
  ```bash
  make bonus_log
  ```

## Accessing Services

Once the containers are running, you can access the services via your browser:

- **WordPress Site**: `https://your_login.42.fr`
- **Adminer (Bonus)**: `https://your_login.42.fr/adminer` (or as configured)
- **Static Page (Bonus)**: `https://your_login.42.fr/static` (or as configured)

> **Note**: Since we use self-signed certificates for TLS, your browser will show a security warning. You can safely "Proceed to site (unsafe)".

## Stopping and Cleaning Up

- **Stop all services**:
  ```bash
  make down
  ```
- **Full cleanup** (Removes images, volumes, and networks - *Use with caution*):
  ```bash
  # You may need to add rules for clean/fclean in your Makefile if not present
  # Currently, 'make down' only stops containers.
  ```

## Troubleshooting

- **Containers not starting**: Check if the ports (443, 80) are already in use by another service on your host machine.
- **Database connection error**: Ensure that the MariaDB container is healthy and that the credentials in your `.env` file match the WordPress configuration.
- **Permission issues**: Ensure your user has permissions to write to the volume paths defined in the Docker Compose files.
