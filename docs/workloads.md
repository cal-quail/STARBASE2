# Workloads

| VM / service | OS / stack | Status | Purpose |
| --- | --- | --- | --- |
| FOG imaging server | Ubuntu Server, FOG 1.5.10 | Live | StarDeploy PXE imaging ([stardeploy.md](stardeploy.md)) |
| Domain controller | Windows Server, AD DS + DNS + AD CS | Live | Laptops OU, GPOs ([fleet-management.md](fleet-management.md)); user/group source for SSO |
| Core services VM | Ubuntu, cloudflared, Caddy | Live | Cloudflare Tunnel connector, public site ([web-and-sso.md](web-and-sso.md)), fan control page |
| Monitoring VM | Ubuntu + Docker | Live | Zabbix, Prometheus, Grafana, NetBox ([monitoring.md](monitoring.md)) |
| SSO VM | Ubuntu + Docker, Authentik | Live | Single sign-on for rack services ([web-and-sso.md](web-and-sso.md)) |
| Weather simulation VM | Ubuntu, WRF + WPS | Live | Hyperlocal weather model centered on the school |
| Minecraft server | Ubuntu, Crafty Controller, Fabric | Stopped | Side project, public via playit.gg (no ports opened) |
| PNETLab | PNETLab | Planned | Browser-based network labs for students |
| Tactical RMM | TBD | Planned | Remote management for the laptop fleet |
| TrueNAS | TrueNAS + passed-through HBA | Planned | See [roadmap](roadmap.md) |

## Minecraft JVM tuning

- Give the VM more RAM than the heap (heap + about 1–2 GB for the OS).
- Set `-Xms` equal to `-Xmx`.
- Use G1GC with Aikar's flags to cut lag spikes.

Tunnel addresses and admin logins are not stored here.
