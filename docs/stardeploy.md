# StarDeploy: PXE laptop imaging

Re-image a batch of school laptops over PXE from the rack. **Status (Nov 2026): imaging works end to end.** Laptops come off the bench named, domain-joined and on the tailnet. The first batch is imaged.

## Why FOG

Open source (GPLv3), actively maintained, full web GUI: dashboard, host management, scheduling, multicast. Chosen over Clonezilla SE (CLI/DRBL only). CloneDeploy is the fallback.

## FOG server VM

| Setting | Value |
| --- | --- |
| OS | Ubuntu Server, FOG 1.5.10.x via the official installer |
| Size | FOG needs 2 vCPU / 2 GB minimum |
| NIC 1 (ens18) | `vmbr0` → production, static IP, web GUI / management |
| NIC 2 (ens19) | Bridge to a physical port cabled only to the imaging switches, `<imaging-subnet>.1/24` |
| Disks | OS disk + separate disk for `/images` |
| FOG DHCP | Full DHCP server on the imaging subnet |
| Imaging-network egress | Narrow path only: the imaging network can reach the DC's AD ports and the internet (NAT through FOG), nothing else on production |
| Hardening | Key-only SSH, host firewall (production side: SSH and web only), database on localhost, NFS exports limited to the imaging subnet |

ens19 is FOG's primary interface: PXE clients need HTTP back to FOG after DHCP/TFTP, not just DHCP.

## How a laptop gets imaged

1. **PXE boot** on the imaging switches. The FOG boot menu shows for 3 s.
2. **Unknown laptops** default to *Quick Registration*: they get the next `LAB-NNN` name and join the `lab-laptops` group, which carries the image, the AD settings and the snapins. They start imaging right away. Registered laptops boot from disk.
3. After imaging, the **FOG client** renames the laptop, **joins the domain** and runs the **post-image snapin**.

Stock FOG 1.5.10 quick registration only adds the group; it doesn't copy the group's AD settings or snapins to the new host. A small FOG hook plug-in does that, so quick-registered laptops really join AD and run the snapin. Shared virtual network adapters (VMware, VirtualBox, Npcap, Hyper-V) are ignored when matching hosts, so clones stop being mistaken for the golden laptop.

## Post-image snapin

A FOG **snapin pack** (PowerShell + bundled installers) that runs as SYSTEM after imaging:

- Installs **Tailscale** from the bundled MSI and joins the tailnet with a reusable, tagged key that FOG passes in at run time. The key is **not** in the image, because the image share is readable on the LAN. With no internet yet, the key waits in a SYSTEM-only file and a startup task retries.
- Resets a Tailscale identity cloned from the golden image, so every laptop becomes its own device.
- Adds the **HP drivers** the image lacks (touchpad Serial IO controller, Intel/Realtek Wi-Fi and Bluetooth) with `pnputil`, on HP laptops only.
- Relaunches itself in 64-bit PowerShell. The FOG client is 32-bit, and 32-bit PowerShell has no `pnputil`, so driver installs silently did nothing before this.

A second, single-file **domain-join snapin** is the fallback for laptops that missed FOG's join. It waits for the DC, joins with the delegated account into the Laptops OU, and exits cleanly if the laptop is already joined.

## Domain join

FOG's Active Directory integration (HostNameChanger) joins imaged hosts to `ad.<domain>` using a delegated, non-admin join account on the Laptops OU. Since the security review, nobody else can add computers (`ms-DS-MachineAccountQuota` = 0).

**Keep "Join Domain after deploy" ticked on the laptop group.** Hosts copy the group's AD settings when they're registered. With the box unticked, every laptop registered during that time silently skips the join. Ticking it again pushes the settings to existing hosts, and the FOG client joins at its next check-in.

## Capacity

- Unicast: 10 at once by default (Storage Management → Max Clients).
- Multicast: up to 64 sessions; use it for batches.
- Fleet is about 80 laptops. Two 8-port switches give about 13 laptop ports per batch. Open decision: smaller batches, a third switch, or CBS350s.

## Golden image

- Windows 11 Education. No volume license is available, so laptops run unactivated for now (advisor sign-off). The image uses the public KMS client key (GVLK), never a real key.
- Shared local account baked in; no per-student domain accounts.
- FOG client installed. **Never capture the image domain-joined**, or every clone shares one computer account.
- Sysprep before capture so every clone gets its own Windows identity. The FOG client is held off during setup and started by `SetupComplete.cmd`.
- Remove Tailscale from the golden laptop before capturing; the snapin installs it fresh.
- USB-Ethernet dongles need a PXE boot ROM; verify per model before buying in bulk.

## Status

- [x] Phase 0: decisions
- [x] Phase 1: FOG VM built and hardened
- [x] First imaging switch connected to FOG
- [x] Golden image captured, one-button imaging, post-image snapin
- [x] First laptops imaged, domain-joined and on the tailnet
- [ ] Fix clones that come out with MAC-style hostnames instead of `LAB-NNN`
- [ ] Second imaging switch on the same VLAN
- [ ] Bake the full HP driver pack into the next golden image
