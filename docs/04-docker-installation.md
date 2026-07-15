# Docker Installation and Host Preparation

## Objective

This phase prepares the Fedora host to run the Wazuh platform using containers. Docker provides an isolated and reproducible environment for deploying the Wazuh Manager, Indexer, and Dashboard without installing them directly on the host operating system.

By containerizing the SIEM platform, the host remains clean, deployment becomes repeatable, and the entire environment can be recreated on another machine with minimal effort.

---

# Environment

| Component        | Value                                     |
| ---------------- | ----------------------------------------- |
| Operating System | Fedora Linux 44 (KDE Plasma)              |
| Processor        | Intel Core i5-6200U (2 Cores / 4 Threads) |
| Memory           | 8 GB RAM                                  |
| Storage          | 220 GB SSD                                |
| Virtualization   | Intel VT-x                                |

---

# Prerequisites

Before installing Docker:

* Update the operating system.
* Remove any legacy Docker packages.
* Configure Docker's official package repository.
* Install the Docker Engine and Docker Compose plugin.
* Enable the Docker service.
* Allow the current user to execute Docker commands without requiring `sudo`.

---

# Installation Procedure

## 1. Update Fedora

```bash
sudo dnf upgrade --refresh
```

Reboot the system if a new kernel is installed.

---

## 2. Remove Legacy Docker Packages

```bash
sudo dnf remove \
docker \
docker-client \
docker-client-latest \
docker-common \
docker-latest \
docker-latest-logrotate \
docker-logrotate \
docker-engine
```

This ensures that previous installations do not conflict with Docker CE.

---

## 3. Install the DNF Plugin

```bash
sudo dnf install -y dnf-plugins-core
```

---

## 4. Add Docker's Official Repository

```bash
sudo dnf config-manager addrepo \
--from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
```

Using Docker's official repository provides access to the latest stable releases.

---

## 5. Install Docker

```bash
sudo dnf install -y \
docker-ce \
docker-ce-cli \
containerd.io \
docker-buildx-plugin \
docker-compose-plugin
```

Installed components include:

* Docker Engine
* Docker CLI
* containerd
* Buildx
* Docker Compose

---

## 6. Enable Docker

```bash
sudo systemctl enable --now docker
```

Verify that Docker is running:

```bash
systemctl status docker
```

Expected status:

```
Active: active (running)
```

---

## 7. Configure User Permissions

Allow the current user to execute Docker commands without `sudo`.

```bash
sudo usermod -aG docker $USER
```

Apply the new group membership:

```bash
newgrp docker
```

Alternatively, log out and back in.

---

## 8. Verify Docker Installation

Check the installed versions.

```bash
docker --version

docker compose version
```

Run the Docker test container.

```bash
docker run hello-world
```

Successful output confirms that:

* Docker Engine is operational.
* The client can communicate with the daemon.
* Container networking and image downloads are functioning correctly.

---

# Docker Configuration

To prevent uncontrolled log growth, Docker was configured to rotate container logs automatically.

Create the Docker configuration directory if it does not already exist.

```bash
sudo mkdir -p /etc/docker
```

Create `/etc/docker/daemon.json`.

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "live-restore": true
}
```

Restart Docker.

```bash
sudo systemctl restart docker
```

### Configuration Benefits

* Limits container log growth.
* Prevents disk exhaustion caused by oversized logs.
* Allows containers to continue running if the Docker daemon is restarted.

---

# Validation

Collect Docker environment information.

```bash
docker info
```

Important values to verify include:

* Docker Version
* Storage Driver
* Cgroup Version
* CPU Count
* Available Memory
* Logging Driver

These values establish the baseline environment for future troubleshooting.

---

# Challenges Encountered

No major issues were encountered during the Docker installation.

Potential issues that may arise on Fedora include:

* SELinux policy restrictions
* Firewall configuration
* Legacy Docker packages
* User group membership requiring a new login session

Each issue can typically be resolved without reinstalling Docker.

---

# Lessons Learned

Deploying infrastructure in containers provides several advantages over installing services directly on the host:

* Improved isolation between services and the operating system.
* Simplified upgrades and rollback procedures.
* Reproducible deployments across different systems.
* Easier backup and disaster recovery.
* Better alignment with modern DevSecOps and cloud-native deployment practices.

Containerization also enables this project to remain portable, allowing the complete SIEM environment to be recreated using version-controlled configuration files.

---

# Outcome

At the conclusion of this phase:

* Docker Engine was successfully installed.
* Docker Compose is available.
* Docker starts automatically at boot.
* The current user can execute Docker commands without elevated privileges.
* Container execution was verified using the `hello-world` image.
* Docker has been configured with log rotation and live restore.
* The host is fully prepared for deploying the official Wazuh Docker stack
