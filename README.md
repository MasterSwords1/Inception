*This project has been created as part of the 42 curriculum by ariyad.*

# Inception

A 42 Network system administration project focused on infrastructure containerization using Docker, Docker Compose, and custom container images running on a Linux Virtual Machine.

---

## 📄 Description

The **Inception** project requires building a complete multi-container web infrastructure adhering to strict system administration and security guidelines. Every service runs in its own dedicated, isolated container built from a custom `Dockerfile` based on Debian Bookworm (or Alpine). The application is fully managed via a root-level `Makefile` and orchestrated with `docker compose`.

### 🔑 Key Goals & Scope
- **Strict Isolation**: Each daemon/service operates within a separate, dedicated container without unneeded packages or hacky patches (no `tail -f`, `sleep infinity`, or multi-service containers).
- **Security & TLS**: NGINX serves as the single public entrypoint over Port 443 strictly using TLSv1.2 or TLSv1.3 protocols.
- **Automation & Persistence**: Data persists in dedicated named volumes mapped to host storage at `/home/ariyad/data/`. WordPress is automatically installed and configured via WP-CLI.

---

## 🐳 Project Description & Design Choices

### Infrastructure Architecture

The project contains two configurations:
1. **Mandatory Stack**:
   - **NGINX**: Public HTTPS entrypoint listening on port 443 with TLSv1.2/v1.3 forwarding FastCGI requests to WordPress.
   - **WordPress + PHP-FPM**: Custom application container executing PHP 8.2-FPM and automated initialization via WP-CLI.
   - **MariaDB**: Relational database engine storing WordPress content and user accounts.

2. **Bonus Stack**:
   - **Redis Cache**: High-performance object caching backend for WordPress.
   - **SFTP Server**: Secure file transfer access to WordPress upload directory via OpenSSH.
   - **Adminer**: Lightweight single-file database management interface.
   - **Static Site**: Fast showcase web page built in HTML/CSS/JS (no PHP).
   - **Owncast**: Self-hosted live video streaming server.

### Design Choices
- **Base OS**: All images are built from `debian:bookworm` for maximum stability, package availability, and security updates.
- **Service Communication**: Containers communicate strictly over a custom bridge network (`my_net`). Port binding to the host is limited to NGINX (443) and specific bonus services.
- **Non-root & Minimal Footprint**: Containers run dedicated daemons as non-root service users where possible, ensuring minimal attack surface.

---

## 🔬 Technical Comparisons

### 1. Virtual Machines vs Docker Containers
| Feature | Virtual Machines (VMs) | Docker Containers |
| :--- | :--- | :--- |
| **Virtualization Level** | Hardware-level (Hypervisor virtualizes CPU, RAM, disk, NIC). | Operating System-level (Shares host OS kernel, isolates namespaces/cgroups). |
| **OS Footprint** | Requires full guest operating system per VM (GBs of storage & RAM). | Shared host kernel, minimal container base image (MBs of storage & RAM). |
| **Boot Time** | Minutes (boots full operating system). | Seconds or milliseconds (starts process tree). |
| **Isolation & Security** | Strong hardware isolation boundary via hypervisor. | Process isolation via Linux namespaces, cgroups, and capabilities. |
| **Performance Overhead** | Higher resource overhead due to hypervisor emulation. | Near-native CPU, memory, and I/O performance. |

*In Inception, Docker containers are chosen to efficiently isolate individual daemons while maintaining high performance and lightweight resource usage within a single host VM.*

---

### 2. Secrets vs Environment Variables
| Feature | Environment Variables (`.env`) | Docker Secrets |
| :--- | :--- | :--- |
| **Storage Location** | Stored in plain-text `.env` files or process environment space. | Stored in memory-backed tmpfs files (`/run/secrets/<secret_name>`). |
| **Process Visibility** | Accessible to any process or child process inside the container via `env` or `/proc/1/environ`. | Accessible only by reading specific file paths on the mounted tmpfs filesystem. |
| **Inspection Risk** | Exposed in `docker inspect` outputs and process monitoring tools. | Never exposed via `docker inspect` or environment dumps. |
| **Use Case** | Non-sensitive configurations (domain names, port numbers, public usernames). | Sensitive credentials (database passwords, admin master keys, API tokens, TLS keys). |

*In Inception, non-sensitive parameters are managed via `.env` files (ignored in `.gitignore`), while sensitive credentials are stored securely outside public git history.*

---

### 3. Docker Network vs Host Network
| Feature | Custom Docker Network (Bridge) | Host Network (`network_mode: host`) |
| :--- | :--- | :--- |
| **Network Isolation** | Isolated network namespace with dedicated virtual subnet. | Shares the host machine's network stack directly. |
| **DNS & Service Discovery** | Embedded Docker DNS resolves container names to internal IPs automatically. | No container name resolution; services bind directly to host interfaces. |
| **Port Exposure** | Ports are closed by default; only explicitly published ports (`ports:`) are reachable from outside. | All listening ports are immediately exposed on host network interfaces. |
| **Security** | High isolation; internal services (e.g. MariaDB) are inaccessible from host network. | No port isolation; port conflicts can occur with host services. |

*In Inception, a custom bridge network (`my_net`) is strictly used as required by the subject, prohibiting `network: host` or legacy `--link` options.*

---

### 4. Docker Volumes vs Bind Mounts
| Feature | Docker Named Volumes | Host Bind Mounts |
| :--- | :--- | :--- |
| **Management** | Fully managed by Docker engine daemon (`/var/lib/docker/volumes/`). | Explicitly paths mapped to existing directories on the host filesystem. |
| **Portability & Host Coupling** | Decoupled from host directory structure; easily managed across environments. | Tied directly to specific host file paths and host permission structures. |
| **Initialization** | Automatically populates new volumes with base container files on first mount. | Overwrites container mount directory with existing host contents (even if empty). |
| **Subject Requirement** | **Mandatory** for WordPress files and MariaDB data in Inception. | Prohibited for mandatory data volumes in Inception. |

*In Inception, dedicated named volumes (`mariadb-data`, `wp-files`) are defined in Docker Compose and configured to persist data on host paths (`/home/ariyad/data/`).*

---

## 🛠️ Instructions

### 1. Prerequisites
Ensure you have the following installed on your host system:
- **Operating System**: Linux (Debian/Ubuntu recommended) inside a Virtual Machine.
- **Tools**: `docker` (v24.0+), `docker compose` (v2.20+), `make`, and `git`.

### 2. Host Domain Setup
Map your local 42 domain (`ariyad.42.fr`) to your loopback IP address in `/etc/hosts`:
```bash
sudo sh -c 'echo "127.0.0.1 ariyad.42.fr" >> /etc/hosts'
```

### 3. Environment Configuration
Copy the template `.env.example` files to `.env` and fill in your passwords and credentials:
```bash
# For Mandatory stack
cp srcs/mandatory/.env.example srcs/mandatory/.env

# For Bonus stack
cp srcs/bonus/.env.example srcs/bonus/.env
```
> [!IMPORTANT]
> Never commit `.env` files or credentials to your Git repository. Ensure database admin usernames do **not** contain `admin` or `administrator`.

### 4. Compilation & Execution Commands

| Command | Action |
| :--- | :--- |
| `make` / `make all` | Creates host data directories and launches all mandatory containers via Docker Compose. |
| `make build` | Builds or rebuilds mandatory container images without starting them. |
| `make bonus` | Creates bonus data directories and launches all services including bonus containers. |
| `make bonus_build` | Builds or rebuilds bonus container images. |
| `make stats` / `make bonus_stats` | Displays container running status, ports, and healthcheck states. |
| `make log` / `make bonus_log` | Displays the last 10 lines of container logs. |
| `make down` | Stops and removes active mandatory and bonus containers. |
| `make clean` | Stops containers and removes created Docker images. |
| `make fclean` | Full cleanup: removes containers, images, networks, volumes, and host data directories. |
| `make re` | Performs `fclean` followed by `all` for a complete fresh rebuild. |

---

## 📚 Resources & AI Usage

### References & Documentation
- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Compose Specification](https://docs.docker.com/compose/)
- [NGINX Documentation & TLS Setup](https://nginx.org/en/docs/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)
- [WordPress CLI (WP-CLI) Commands](https://developer.wordpress.org/cli/commands/)
- [Debian Bookworm Documentation](https://www.debian.org/doc/)

### AI Usage Description
In accordance with Chapter IV of the 42 subject rules, AI assistance (specifically Google Antigravity) was used in the development of this project for the following tasks:

1. **Documentation Formatting & Structuring**:
   - Structuring Markdown files ([`README.md`](file:///home/abderahmanriyad15/Inception/README.md), [`USER_DOC.md`](file:///home/abderahmanriyad15/Inception/USER_DOC.md), [`DEV_DOC.md`](file:///home/abderahmanriyad15/Inception/DEV_DOC.md)) to strictly match Chapter VI and Chapter VII specifications.
   - Summarizing comparison tables (VM vs Docker, Secrets vs Env, Docker Network vs Host, Volumes vs Bind Mounts).
2. **Dockerfile & Shell Script Optimization**:
   - Reviewing shell script entrypoints to ensure compliance with PID 1 execution (using `exec` to replace shell processes).
   - Verifying healthcheck commands (e.g. `cgi-fcgi` for PHP-FPM and `mysqladmin ping` for MariaDB).
3. **Validation & Verification**:
   - Every AI-generated suggestion, configuration snippet, and text document was manually reviewed, verified, tested, and validated in a live Virtual Machine environment to ensure complete understanding and technical accuracy.

---

## 📖 Further Documentation
- 👤 **User Guide**: See [`USER_DOC.md`](file:///home/abderahmanriyad15/Inception/USER_DOC.md) for service access, credential management, and status checking.
- 💻 **Developer Guide**: See [`DEV_DOC.md`](file:///home/abderahmanriyad15/Inception/DEV_DOC.md) for architecture deep-dives, build pipelines, and troubleshooting.
