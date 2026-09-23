# Proxmox host

Proxmox VE is installed on the RAID5 virtual disk. The web UI is at `https://<proxmox-host-ip>:8006`.

- Version: TODO
- Storage layout (local, local-lvm): TODO

## DNS fix (done)

ISO downloads failed because the node couldn't resolve hostnames.

```bash
cat /etc/resolv.conf            # should list a working nameserver
ping -c 2 1.1.1.1               # works = network is fine, DNS is the problem
ping -c 2 download.proxmox.com
# Fix: set a nameserver (or use Node > System > DNS in the web UI)
echo "nameserver 1.1.1.1" >> /etc/resolv.conf
```

Also confirm the gateway set on `vmbr0` in `/etc/network/interfaces` is correct.
