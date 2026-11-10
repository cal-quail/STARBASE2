# Workloads

| VM / service | Node | OS / stack | Status | Purpose |
| --- | --- | --- | --- | --- |
| Domain controller | 1 | Windows Server 2025 (AD DS, DNS, AD CS), VirtIO | Live | Laptops OU, GPOs, SSO user/group source, ADManager Plus ([fleet-management.md](fleet-management.md)) |
| Core services VM | 1 | Ubuntu, cloudflared, Caddy | Live | Cloudflare Tunnel connector, public site ([web-and-sso.md](web-and-sso.md)), fan control page ([management.md](management.md)) |
| Monitoring VM | 1 | Ubuntu + Docker | Live | Zabbix, Prometheus, Grafana, NetBox ([monitoring.md](monitoring.md)) |
| SSO VM | 1 | Ubuntu + Docker, Authentik | Live | Single sign-on for rack services ([web-and-sso.md](web-and-sso.md)) |
| Lab gateway | 1 | Ubuntu + nftables | Live | Fence between PNETLab and everything else ([pnetlab.md](pnetlab.md)) |
| PNETLab | 1 | Community PNetLab v8 | Live | Student network labs at `lab.<domain>` ([pnetlab.md](pnetlab.md)) |
| Minecraft server | 1 | Ubuntu, Crafty Controller, Fabric | Stopped | Side project, public via playit.gg (no ports opened) |
| FOG imaging server | 2 | Ubuntu Server, FOG 1.5.10 | Live | StarDeploy PXE imaging ([stardeploy.md](stardeploy.md)) |
| Weather simulation | 2 | Ubuntu, WRF + WPS | Live | Hyperlocal forecast + radar nowcast ([weather.md](weather.md)) |
| Remote management (RMM) | — | TBD | Planned | Tactical RMM or MeshCentral for the laptop fleet |
| Proxmox Backup Server | 3 | PBS | Planned | Backups on a third node with ~5 TB ([storage.md](storage.md)) |
| TrueNAS | — | TrueNAS + passed-through HBA | Planned | See [roadmap](roadmap.md) |

Every VM on node 1 is in the nightly backup job ([storage.md](storage.md)).

## Minecraft JVM tuning

- Give the VM more RAM than the heap (heap + about 1–2 GB for the OS).
- Set `-Xms` equal to `-Xmx`.
- Use G1GC with Aikar's flags to cut lag spikes.

Tunnel addresses and admin logins are not stored here.
