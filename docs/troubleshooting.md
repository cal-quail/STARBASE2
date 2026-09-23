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
| Loud fans | iDRAC auto fan profile | IPMI manual fan speed ([management.md](management.md)) |
| PERC "Foreign Configuration" | Existing RAID5 metadata seen as foreign | Import in Ctrl+R ([storage.md](storage.md)) |
