# Monitoring

Decided and built in October 2026: instead of picking one tool, the rack runs four that each do one job well. All of them run as Docker Compose stacks on one monitoring VM (4 vCPU / 8 GB / 100 GB) on the production segment, reachable on the LAN only, with logins through [SSO](web-and-sso.md).

| Tool | Job |
| --- | --- |
| **Zabbix 7.0 LTS** | Core monitoring and alerting: ping, Proxmox API, Cisco via SNMPv3, iDRAC via IPMI, Linux agents |
| **Prometheus** + blackbox exporter | Status / uptime probes (ping, HTTP, TCP), Proxmox exporter, node_exporter |
| **Grafana** | Dashboards from both Prometheus and Zabbix, including a one-page rack status board |
| **NetBox** | Source of truth: site, rack, devices, IP address management, Proxmox VMs (synced nightly) |

## What's monitored

| Target | How |
| --- | --- |
| ISR 1100 | SNMPv3 authPriv (SHA / AES-128), read-only, ACL'd to the monitoring VM, Zabbix "Cisco IOS by SNMP" |
| R720xd hardware (temps, fans, PSUs) | Read-only IPMI user on each iDRAC (USER privilege), Zabbix "Chassis by IPMI" |
| Proxmox cluster, nodes, VMs, storage | Proxmox API with a read-only (PVEAuditor) user and API tokens |
| Linux VMs | Zabbix agent 2 + node_exporter, firewalled so only the monitoring VM can connect |
| Every device on the production network | ICMP ping |
| Web UIs | Blackbox HTTP probes |

## Notes

- Secrets (DB passwords, API tokens, SNMP/IPMI passwords) were generated on the monitoring VM and live only there and in the team vault.
- Nightly: database + config backup (14 days) and NetBox sync from Proxmox. Backups still need an off-box copy.
- Zabbix's Proxmox template needs `{$HTTP.TLS.VERIFY}=none` while Proxmox uses its self-signed certificate.
- The iDRAC web UI answers `302` and then `404` if you follow the redirect, so its HTTP probe accepts the redirect without following it.
- The imaging switches are on the isolated imaging segment, so they're deliberately not reachable from the monitoring VM.
- Everything was set up through each tool's API with re-runnable scripts, so the config can be rebuilt.

## Still to do

- [ ] Email alerts (configured, waiting on an app password) and a second alert channel
- [ ] Windows agent on the domain controller
- [ ] Management IP + SNMPv3 on the 3750E (needs a console cable)
- [ ] Off-box copy of the monitoring backups
