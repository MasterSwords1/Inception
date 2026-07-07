*This project has been created as part of the 42 curriculum by ariyad*

# Inception

## Description

Inception is a system administration and infrastructure project from the 42 curriculum focused on containerization using Docker.

The goal of the project is to build a small virtualized infrastructure composed of multiple interconnected services running inside Docker containers. Each service is isolated, reproducible, and managed through Docker Compose.

The infrastructure generally includes:

* An NGINX container configured with TLS
* A WordPress container running with PHP-FPM
* A MariaDB container for the database
* Persistent storage using Docker volumes
* A dedicated Docker network for communication between containers

The project introduces important DevOps and system administration concepts such as:

* Containerization
* Service orchestration
* Networking
* Volumes and persistence
* Environment configuration
* Security and secrets management

The objective is to understand how modern infrastructures are deployed while learning how Docker simplifies application isolation and reproducibility.

---

# Project Architecture

## Infrastructure Overview

The project is composed of multiple Docker containers orchestrated with Docker Compose.

### Main Services

| Service        | Purpose                                |
| -------------- | -------------------------------------- |
| NGINX          | Reverse proxy and HTTPS server         |
| WordPress      | PHP application running with PHP-FPM   |
| MariaDB        | Database service                       |
| Docker Network | Communication layer between containers |
| Docker Volumes | Persistent data storage                |

---

# Technical Choices

## Why Docker?

Docker allows applications and services to run inside isolated environments called containers.

Advantages:

* Reproducibility
* Isolation
* Lightweight virtualization
* Easy deployment
* Better dependency management

The project uses:

* Docker
* Docker Compose
* Debian bookworm images

---

# Virtual Machines vs Docker

| Virtual Machines                    | Docker Containers       |
| ----------------------------------- | ----------------------- |
| Emulate a complete operating system | Share the host kernel   |
| Heavy resource usage                | Lightweight             |
| Slow startup time                   | Fast startup            |
| Larger disk usage                   | Smaller images          |
| Strong isolation                    | Process-level isolation |

Docker was chosen because it provides lightweight and efficient containerization suitable for modern infrastructures.

---

# Secrets vs Environment Variables

## Environment Variables

Environment variables are commonly used to configure containers dynamically.

Examples:

* Database names
* Ports
* Service configuration

Advantages:

* Easy to configure
* Flexible
* Supported directly by Docker Compose

Limitations:

* Not secure for sensitive data
* Can be exposed in logs or configuration files

---

## Docker Secrets

Secrets are designed to securely store sensitive information.

Examples:

* Database passwords
* API keys
* Certificates

Advantages:

* Better security
* Restricted access
* Not exposed directly in container environments

In this project, secrets are used whenever sensitive credentials are required.

---

# Docker Network vs Host Network

## Docker Network

Docker networks allow containers to communicate securely and independently from the host machine.

Advantages:

* Isolation
* Internal DNS resolution
* Better security
* Controlled communication

---

## Host Network

Host mode removes network isolation and allows containers to use the host network directly.

Advantages:

* Better performance
* Simpler networking

Disadvantages:

* Reduced isolation
* Increased security risks

The project uses Docker bridge networks to maintain proper isolation between services.

---

# Docker Volumes vs Bind Mounts

## Docker Volumes

Volumes are managed directly by Docker.

Advantages:

* Better portability
* Easier backups
* Docker-managed lifecycle
* Recommended for persistent data

Used for:

* Database persistence
* WordPress files

---

## Bind Mounts

Bind mounts connect directories from the host machine directly into containers.

Advantages:

* Easy development workflow
* Direct file access

Disadvantages:

* Host-dependent paths
* Less portable

Volumes are preferred in this project for better portability and persistence.

---

# Instructions

## Requirements

Before running the project, make sure the following tools are installed:

* Docker
* Docker Compose
* Make

---

## Installation

Clone the repository:

```bash
git clone <repository_url>
cd inception
```

---

## Build and Start Containers

Run:

```bash
make
```

or:

```bash
docker compose up --build
```

---

## Stop Containers

```bash
make clean
```

or:

```bash
docker compose down
```

---

## Remove Containers, Images, and Volumes

```bash
make fclean
```

---

# Project Structure

```text
.
├── Makefile
├── srcs/
│   ├── docker-compose.yml
│   ├── requirements/
│   │   ├── nginx/
│   │   ├── wordpress/
│   │   └── mariadb/
│   └── .env
└── README.md
```

---

# Usage

Once the containers are running:

1. Open your browser
2. Access:

   ```text
   https://localhost
   ```
3. Configure WordPress if necessary

---

# Security

This project uses:

* TLS/SSL with NGINX
* Isolated Docker containers
* Dedicated Docker network
* Persistent volumes
* Environment configuration through `.env` files
* Secure password management

---

# Resources

## Docker Documentation

* Docker Official Documentation
  https://docs.docker.com/

* Docker Compose Documentation
  https://docs.docker.com/compose/

* NGINX Documentation
  https://nginx.org/en/docs/

* MariaDB Documentation
  https://mariadb.org/documentation/

* WordPress Documentation
  https://developer.wordpress.org/

---

## Tutorials and Articles

* Docker Networking Overview
  https://docs.docker.com/network/

* Docker Volumes
  https://docs.docker.com/storage/volumes/

* Best Practices for Dockerfiles
  https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

---

# AI Usage

AI tools were used during the development of the project for:

* Understanding Docker concepts
* Learning Docker Compose syntax
* Troubleshooting configuration issues
* Explaining networking and volumes
* Improving documentation quality

AI assistance was limited to educational support and debugging guidance. All configuration, implementation, and testing were completed manually.

---

# Conclusion

This project provides practical experience with Docker-based infrastructures and introduces fundamental DevOps concepts such as container orchestration, networking, persistence, and service isolation.

It serves as an introduction to modern deployment workflows and scalable infrastructure design.
