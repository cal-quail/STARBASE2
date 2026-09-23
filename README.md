# STARBASE 2

The server rack in our school's cybersecurity classroom. It runs the projects the program needs (laptop imaging with StarDeploy, a domain controller, fleet management, the public website) plus side projects, on Proxmox VE across two Dell R720xd servers.

> **Redaction note:** every IP address, hostname, domain, account name, password and serial number in this repo is a placeholder (`<idrac-ip>`, `<domain>`, `<user>` …). Real values go in a local `.env` file (git-ignored) or the team password vault.

## Components

| Component | Role |
| --- | --- |
| Cisco ISR 1100 | Router, uplink to the district network |
| Cisco WS-C3750E-24TD | Core production switch |
| 2× Dell R720xd | Proxmox VE hosts (15 TB storage, 256 GB DDR3) |
| 2× Cisco CBS250-8FP-E-2G | Isolated imaging switches for StarDeploy |
| iDRAC 7 | Out-of-band management on each server |

## Docs

| File | Covers |
| --- | --- |
| [hardware.md](docs/hardware.md) | Servers and network gear |
| [network.md](docs/network.md) | Production vs imaging segments, district network rules |
| [stardeploy.md](docs/stardeploy.md) | FOG PXE imaging project |
| [fleet-management.md](docs/fleet-management.md) | Managing laptops after they leave the rack |
| [web-and-sso.md](docs/web-and-sso.md) | Hosting the public site, SSO options |
| [storage.md](docs/storage.md) | RAID5 array, Foreign Configuration fix |
| [management.md](docs/management.md) | iDRAC 7, HTML5 console, IPMI fan control |
| [proxmox.md](docs/proxmox.md) | Proxmox host setup, DNS fix |
| [workloads.md](docs/workloads.md) | VMs and services |
| [troubleshooting.md](docs/troubleshooting.md) | Issues hit and how they were fixed |
| [roadmap.md](docs/roadmap.md) | What's next |

## Scripts

| Script | Does |
| --- | --- |
| [scripts/fan-control.sh](scripts/fan-control.sh) | Manual / auto fan control over IPMI |

## Setup

```bash
cp .env.example .env   # fill in real values; never commit .env
./scripts/fan-control.sh status
```
