# Proxmox host

Proxmox VE 9.2 runs on both R720xd servers as a two-node cluster. The web UI is at `https://<proxmox-host-ip>:8006` on either node.

- Storage layout: `local` (ISOs, templates) and `local-lvm` (VM disks) on each node's RAID5 virtual disk, plus a backup volume ([storage.md](storage.md)).
- New VMs are built from the Ubuntu cloud image with cloud-init (`qm create` + `import-from`, `--ciuser`, `--sshkeys`, a static `--ipconfig0`, `--nameserver "8.8.8.8 8.8.4.4"`).
- After a kernel update, reboot each node (one at a time, after school) or it keeps running the old kernel.

## Windows VMs: use VirtIO

The DC was originally built with an emulated **IDE** disk and an emulated **e1000** NIC, and with all 16 cores across both sockets. RDP and Windows Admin Center crawled even on a wired connection. Moving it to VirtIO, 8 vCPU with NUMA on and the QEMU guest agent fixed it. Safe order for any Windows VM:

1. **Back up the VM first.**
2. Mount the `virtio-win` ISO and run `virtio-win-gt-x64.msi` and `virtio-win-guest-tools.exe` inside Windows.
3. **While still booting from IDE**, add a small extra SCSI disk and reboot once, so Windows actually loads the `vioscsi` driver. Skip this and Boot Manager stops with **0xc0000225** when the boot disk moves to SCSI. A controller hot-added to a running UEFI VM shows PnP error **code 12** until that reboot.
4. Shut down. Detach the disk (`qm set <id> --delete ide0`, so it becomes `unusedN`), then attach it as `scsi0` with discard + IO thread + SSD emulation and set the boot order to `scsi0`.
5. Boot, then remove the extra disk. Switch the NIC to VirtIO separately and keep the MAC. Windows sees a new adapter on DHCP, so set the static IP again (the guest agent can do this without the console).

> ⚠️ **`qm set <id> --delete unusedN` permanently deletes that disk.** It doesn't just tidy the list. To re-attach a detached disk, set it as `scsi0` (or another bus) directly; Proxmox removes the `unusedN` entry itself.

**Don't run Hyper-V inside a VM on these hosts.** The E5-2670 (Sandy Bridge) has no VMCS shadowing, so nested Hyper-V slows down the whole guest.

## Recovering a single VM disk from a backup

Restore the backup to a **temporary VMID** (nothing on the original VM is touched), then move only the disk you need across:

```bash
qmrestore /path/to/vzdump-qemu-<id>-<date>.vma.zst <tmp-id> --storage local-lvm
qm disk move <tmp-id> ide0 --target-vmid <id> --target-disk scsi0   # reassigns (renames) the volume
qm destroy <tmp-id> --purge                                          # removes only the temp VM's own disks
```

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
# Fix: set a nameserver (Node > System > DNS in the web UI). Not 1.1.1.1: the district network black-holes it.
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
```

## Gateway typo (fixed)

One node had `gateway <prod-subnet>.0` (the network address) instead of `.1` on `vmbr0` in `/etc/network/interfaces`. The node had no internet or DNS, and SSO failed on that node only. Fix the file, then apply it live without reloading the network:

```bash
ip route replace default via <gateway-ip> dev vmbr0
```
