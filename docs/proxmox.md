# Proxmox host

Proxmox VE 9 runs on both R720xd servers as a two-node cluster. The web UI is at `https://<proxmox-host-ip>:8006` on either node.

- Storage layout: `local` (ISOs, templates) and `local-lvm` (VM disks) on each node's RAID5 virtual disk.
- New VMs are built from the Ubuntu cloud image with cloud-init (`qm create` + `import-from`, `--ciuser`, `--sshkeys`, a static `--ipconfig0`, `--nameserver "8.8.8.8 8.8.4.4"`).

## Logins

- **SSO realm** (OpenID Connect via Authentik, see [web-and-sso.md](web-and-sso.md)): pick it in the Realm dropdown on the login screen. Rack admins get Administrator, the rest of the team gets PVEAuditor. Groups come from AD on every login.
- `root@pam` stays as the break-glass login.
- A read-only `PVEAuditor` user with API tokens feeds [monitoring](monitoring.md).

## Two-node quorum

A cluster needs a majority vote. With two nodes, if one goes down the other loses quorum and can't start or change VMs. Fix: a **QDevice** (a tiny third voter) on another always-on machine. Planned with the backup machine.

## DNS fix (done)

ISO downloads failed because the node couldn't resolve hostnames.

```bash
cat /etc/resolv.conf            # should list a working nameserver
ping -c 2 8.8.8.8               # works = network is fine, DNS is the problem
ping -c 2 download.proxmox.com
# Fix: set a nameserver (or use Node > System > DNS in the web UI)
# Fix: set a nameserver (Node > System > DNS in the web UI). Not 1.1.1.1: the district network black-holes it.
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
```

## Gateway typo (fixed)

One node had `gateway <prod-subnet>.0` (the network address) instead of `.1` on `vmbr0` in `/etc/network/interfaces`. The node had no internet or DNS, and SSO failed on that node only. Fix the file, then apply it live without reloading the network:

```bash
ip route replace default via <gateway-ip> dev vmbr0
```
