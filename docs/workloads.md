# Workloads

| VM / service | OS / stack | Status | Purpose |
| --- | --- | --- | --- |
| FOG imaging server | Ubuntu Server, FOG 1.5.10 | Live | StarDeploy PXE imaging ([stardeploy.md](stardeploy.md)) |
| Domain controller | Windows Server, AD DS + DNS | Live | Laptops OU, GPOs ([fleet-management.md](fleet-management.md)) |
| Core services VM | Ubuntu, cloudflared | Live | Cloudflare Tunnel connector |
| Minecraft server | Ubuntu, Crafty Controller, Fabric | Live | Side project, public via playit.gg (no ports opened) |
| Web server | Ubuntu + Caddy | Planned | Hosts the public site ([web-and-sso.md](web-and-sso.md)) |
| Authentik | TBD | Evaluating | Single sign-on for rack services |
| Tactical RMM | TBD | Planned | Remote management for the laptop fleet |
| TrueNAS | TrueNAS + passed-through HBA | Planned | See [roadmap](roadmap.md) |

## Minecraft JVM tuning

- Give the VM more RAM than the heap (heap + about 1–2 GB for the OS).
- Set `-Xms` equal to `-Xmx`.
- Use G1GC with Aikar's flags to cut lag spikes.

Tunnel addresses and admin logins are not stored here.
