# Wazuh Deployment Using Docker

## Objective

The objective of this phase is to deploy a fully containerized Wazuh Security Information and Event Management (SIEM) platform using the official Wazuh Docker deployment.

Running Wazuh inside Docker provides an isolated, reproducible, and portable environment while keeping the Fedora workstation free from application-specific dependencies. This approach aligns with modern infrastructure practices and simplifies upgrades, maintenance, and disaster recovery.

---

# Deployment Architecture

The deployment uses Wazuh's official **single-node** architecture.

```text
                    Fedora 44 Host
┌──────────────────────────────────────────────────────────┐
│                                                          │
│ Docker Engine                                            │
│                                                          │
│ ┌──────────────────────────────────────────────────────┐ │
│ │                 Wazuh Docker Stack                   │ │
│ │                                                      │ │
│ │  ┌─────────────┐   ┌──────────────┐                  │ │
│ │  │ Dashboard   │◄──►│  Indexer     │                 │ │
│ │  └─────────────┘   └──────┬───────┘                 │ │
│ │                            │                        │ │
│ │                     ┌──────▼──────┐                 │ │
│ │                     │   Manager    │                 │ │
│ │                     └──────────────┘                 │ │
│ └──────────────────────────────────────────────────────┘ │
│                                                          │
│ Fedora Wazuh Agent (to be installed later)               │
└──────────────────────────────────────────────────────────┘
```

---

# Why Docker?

Instead of installing Wazuh directly on the host operating system, Docker was selected for several reasons:

* Better service isolation
* Simplified upgrades
* Easy rollback capability
* Reproducible deployments
* Version-controlled infrastructure
* Minimal impact on the Fedora workstation
* Better alignment with DevSecOps practices

This approach also allows the deployment to be recreated on another machine using only the repository documentation.

---

# Deployment Source

The deployment uses the official Wazuh Docker repository.

Repository:

https://github.com/wazuh/wazuh-docker

Deployment:

* Single-node

This repository is maintained separately from this project to simplify future upgrades and reduce unnecessary modifications to upstream files.

---

# Components

The deployment consists of three primary services.

## Wazuh Manager

Responsibilities include:

* Agent management
* Log analysis
* Rule evaluation
* Active response
* Alert generation

---

## Wazuh Indexer

The Indexer is responsible for:

* Storing security events
* Indexing alerts
* Performing searches
* Providing data for dashboards

---

## Wazuh Dashboard

The Dashboard provides:

* Visualization
* Alert investigation
* Threat hunting
* Agent management
* Dashboard customization

---

# Certificate Generation

Communication between Wazuh components is encrypted using TLS.

Before starting the environment, the official certificate generator creates certificates for:

* Root Certificate Authority
* Wazuh Manager
* Wazuh Indexer
* Wazuh Dashboard
* Administrative user

These certificates enable secure communication between all services.

---

# Fedora-Specific Challenge

During certificate generation, the deployment failed with the following error:

```text
cp: cannot stat '/config/certs.yml': Permission denied

ERROR: No configuration file found
```

Although the file existed on the host, the Docker container could not read it.

---

# Root Cause Analysis

Fedora uses SELinux in **Enforcing** mode.

The project directory resided inside the user's home directory, where files were labeled with the SELinux context:

```text
user_home_t
```

Docker containers execute under the SELinux context:

```text
container_t
```

The container was therefore prevented from reading the mounted configuration file.

The issue was confirmed using:

```bash
sudo ausearch -m AVC -ts recent
```

Result:

```text
avc: denied { read }

scontext=container_t

tcontext=user_home_t
```

This confirmed an SELinux Access Vector Cache (AVC) denial rather than a traditional UNIX file permission problem.

---

# Resolution

The deployment directory was relabeled for container access.

```bash
sudo chcon -R -t container_file_t single-node
```

After relabeling, certificate generation completed successfully.

Rather than disabling SELinux, the correct security policy was applied to the project directory, preserving the security posture of the Fedora workstation.

---

# Security Considerations

The decision was made **not** to install Wazuh directly on the Fedora host.

Benefits include:

* Reduced host attack surface
* Isolation between services
* Simplified maintenance
* Easier backup and recovery
* Reproducible deployments
* Separation between infrastructure and endpoint

The Fedora workstation will instead be monitored as an endpoint using the Wazuh Agent in a later phase.

---

# Validation

The deployment will be considered successful when the following services are operational:

* Wazuh Manager
* Wazuh Indexer
* Wazuh Dashboard

Validation steps include:

* Docker container health checks
* Dashboard accessibility
* Successful authentication
* Agent enrollment
* Alert generation

---

# Lessons Learned

Several operational lessons emerged during deployment:

* SELinux denials should be investigated using audit logs before changing permissions.
* Docker bind mounts on Fedora require appropriate SELinux labels.
* Vendor deployment files should remain separate from project documentation to simplify maintenance.
* Containerized deployments improve reproducibility and align with infrastructure-as-code principles.
