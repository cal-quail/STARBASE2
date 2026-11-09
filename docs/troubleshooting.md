# Troubleshooting log

| Issue | Cause | Fix |
| --- | --- | --- |
| `tailscale up --login-server` hangs; `POST /ts2021` → 500 | cloudflared strips the Upgrade header on POST | Headscale dropped; normal HTTP sites through the tunnel are unaffected |
| DNS lookups stall ~15 s | District network black-holes 1.1.1.1 | Static netplan with 8.8.8.8 / 8.8.4.4 |
| dcdiag floods "Access denied" | Local account / not elevated | Elevated prompt as a domain admin; RID-pool warning clears after one reboot |
| FOG GUI unreachable from production | Management NIC's DHCP lease drifted | Static IP in netplan, matched by MAC |
| AD promotion on the wrong option | Wizard on "existing domain" | Choose "Add a new forest" |
| Planned to stack the CBS250s | CBS250 doesn't stack | Two independent switches + LAG |
| Minecraft lag with multiple players | JVM heap/GC pressure | Tune heap and GC flags (in progress) |
| Proxmox ISO downloads failing | Node couldn't resolve DNS | Set a working nameserver ([proxmox.md](proxmox.md)) |
| iDRAC console won't launch on Mac | Java/native libraries unsupported on Apple Silicon | HTML5 console |
| Loud fans | iDRAC auto fan profile | Fan control page with a school-hours schedule ([management.md](management.md)) |
| apt on a VM can't resolve anything | VM's DNS pointed at the router, which doesn't serve DNS | 8.8.8.8 / 8.8.4.4 in netplan |
| One Proxmox node has no internet | Gateway set to the network address (`.0`) instead of `.1` | Fix `/etc/network/interfaces` + `ip route replace` ([proxmox.md](proxmox.md)) |
| iDRAC HTTPS probe fails | iDRAC answers 302, then 404 if followed | Probe accepts the redirect without following it ([monitoring.md](monitoring.md)) |
| Zabbix Proxmox template: "API service not available" | Proxmox self-signed certificate | `{$HTTP.TLS.VERIFY}=none` |
| AD CS install: 0x80072082 ERROR_DS_RANGE_CONSTRAINT | Account not in Enterprise Admins | Add the group, sign out/in, remove the half-made CA, re-run ([web-and-sso.md](web-and-sso.md)) |
| LDAPS port open but no certificate | No CA / DC certificate | AD CS Enterprise Root CA; DC auto-enrolls |
| SSO: "Invalid grant_type for provider" | OIDC provider created with an empty grant types list | Allow `authorization_code` + `refresh_token` |
| NetBox SSO button → HTTP 500 | Wrong setting name / trailing slash | `SOCIAL_AUTH_OIDC_OIDC_ENDPOINT`, no trailing slash |
| Zabbix SAML login bounces back | User group frontend access set to Disabled | System default |
| Google button: "Flow does not apply to current user" | Source flow required a signed-out user | Flow authentication "none" |
| Google wouldn't publish the OAuth app | Needs homepage + privacy URLs; app name must appear on the homepage | Small about/privacy pages on the SSO hostname |
| Any MPI program crashes with "illegal instruction" | Distro OpenMPI links libpsm2, which needs AVX2 (these Xeons don't have it) | Build OpenMPI from source without psm2 |
| PERC "Foreign Configuration" | Existing RAID5 metadata seen as foreign | Import in Ctrl+R ([storage.md](storage.md)) |
| RDP and Windows Admin Center on the DC very slow | Emulated IDE disk + e1000 NIC, too many vCPUs across sockets, Hyper-V enabled inside the VM | VirtIO disk and NIC, 8 vCPU + NUMA, Hyper-V removed ([proxmox.md](proxmox.md)) |
| DC's OS disk deleted while moving it from IDE to SCSI | `qm set --delete unusedN` destroys the volume | Restored last night's backup to a temporary VM and reassigned its disk; DC down ~20 min, AD changes since the backup lost ([proxmox.md](proxmox.md)) |
| Boot Manager 0xc0000225 after moving the disk to SCSI | `vioscsi` installed but never loaded | Back to IDE, add a small SCSI disk, reboot once, then move the boot disk |
| VirtIO SCSI controller: PnP error code 12 | Hot-added to a running UEFI (q35) VM | Reboot once |
| ADManager Plus only reachable on the server itself | Not installed as a service (ran only in the RDP session) and no firewall rule | `InstallNTService.bat`, firewall rule for the LAN only |
| Re-registered laptops didn't join the domain | "Join Domain after deploy" unticked on the laptop group | Tick it; fallback domain-join snapin ([stardeploy.md](stardeploy.md)) |
| Quick-registered laptops never joined AD or ran snapins | FOG 1.5.10 quick registration only adds the group | Hook plug-in copies the group's AD settings and snapins ([stardeploy.md](stardeploy.md)) |
| Touchpad dead after imaging | Image lacked the HP Serial IO (I2C) driver | Driver installed by the post-image snapin |
| Snapin driver installs did nothing | FOG client is 32-bit; 32-bit PowerShell has no `pnputil` | Script relaunches itself in 64-bit PowerShell |
| PNETLab timed out after SSO | App redirected to its internal address | Extra Apache vhost for the public name ([pnetlab.md](pnetlab.md)) |
| PNETLab consoles never connected through the tunnel | HTTP/2 broke websockets | Disable HTTP/2 in Apache on the PNETLab VM |
| A manual backup replaced the nightly one | Manual runs count toward "keep daily" | Mark must-keep backups protected ([storage.md](storage.md)) |
