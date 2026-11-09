# Fleet management

After imaging, the ~80 laptops move to the district production network and **never come back to the rack**. Group Policy only applies when a device can reach the DC, so on-prem AD alone can't manage them.

## Tailscale (hosted), live

Headscale was dropped because Cloudflare Tunnel breaks its control handshake. **Hosted Tailscale** connects the laptops and the DC instead:

- The DC has Tailscale, so laptops can reach AD from anywhere: logons, Group Policy, password changes.
- Laptops join with a **reusable, tagged key** (`tag:lab-laptop`, 90-day expiry, device approval on), delivered by the post-image snapin, never baked into the image ([stardeploy.md](stardeploy.md)).
- **Tailnet policy:** laptops can reach **only the DC, and only its AD ports** (DNS, Kerberos, time, RPC endpoint mapper + dynamic range, LDAP/LDAPS, SMB, global catalog). Admins reach everything. The default allow-all policy was replaced.
- The DC's Tailscale adapter must not register in AD DNS; otherwise LAN machines get a second, unreachable address for the domain.

Renew the key every 90 days by pasting the new one into the snapin's arguments in FOG. No image rebuild is needed.

## Still to decide

**Remote management (RMM):** Tactical RMM (an agent that phones home over HTTPS: remote access, monitoring, patching, inventory) or MeshCentral (lighter). Tailscale covers reaching AD but not remote support or inventory.

## Domain controller

- Windows Server VM on the production segment, static IP, DNS pointed at itself.
- AD DS + DNS; forest `ad.<domain>`, a subdomain rather than the public apex, to avoid split-brain DNS. Leave "Create DNS delegation" unchecked.
- Laptops OU, plus a non-admin join account delegated Create/Delete Computer objects on it (for FOG).
- User-side GPO settings (wallpaper) need loopback processing (Merge) because laptops use a local login.
- DNS forwarders: 8.8.8.8 / 8.8.4.4 (not 1.1.1.1).
- **VM hardware:** VirtIO disk and NIC, 8 vCPU with NUMA, QEMU guest agent. Don't enable Hyper-V inside it (see [proxmox.md](proxmox.md)).
- **ManageEngine ADManager Plus** for day-to-day AD admin: installed as a Windows service, port 8080 reachable from the LAN only, never published through the tunnel.
- Run `dcdiag` from an elevated prompt as a domain admin.
