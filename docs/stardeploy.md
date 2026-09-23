# StarDeploy — PXE laptop imaging

Re-image a batch of school laptops over PXE from the rack. **Phase 1 (FOG server) is complete; Phase 2 (switch config) is next.**

## Why FOG

Open source (GPLv3), actively maintained, full web GUI: dashboard, host management, scheduling, multicast. Chosen over Clonezilla SE (CLI/DRBL only). CloneDeploy is the fallback.

## FOG server VM

| Setting | Value |
| --- | --- |
| OS | Ubuntu Server, FOG 1.5.10.x via the official installer |
| Size | FOG needs 2 vCPU / 2 GB minimum |
| NIC 1 (ens18) | `vmbr0` → production, static IP, web GUI / management |
| NIC 2 (ens19) | `vmbr1` → a physical port cabled only to the imaging switches, `<imaging-subnet>.1/24` |
| Disks | OS disk + separate disk for `/images` |
| FOG DHCP | Full DHCP server on the imaging subnet, router = itself, no DNS |
| HTTPS | Off (internal admin tool) |

ens19 is FOG's primary interface: PXE clients need HTTP back to FOG after DHCP/TFTP, not just DHCP. Apache listens on all interfaces, so the GUI works from both.

Default FOG login changed after install.

## Capacity

- Unicast: 10 at once by default (Storage Management → Max Clients, `FOG_QUEUESIZE`).
- Multicast: up to 64 sessions — use it for batches.
- Fleet is about 80 laptops; the two 8-port switches give about 13 laptop ports per batch. Open decision: accept smaller batches, add switches, or move to CBS350s.

## Golden image

- **Plan A:** Windows 11 Education, activated with AD-based Activation (ADBA). Image uses the public Windows 11 Education KMS client key (GVLK), never a real product key.
- **Plan B** (no district volume licensing): Windows 11 Pro, activated by each laptop's firmware-embedded OEM key. Check editions first:
  ```powershell
  wmic path SoftwareLicensingService get OA3xOriginalProductKey
  ```
  Home-edition units need a second image or Pro upgrade keys.
- Shared local account baked in; no per-student domain accounts.
- FOG client with HostNameChanger installed. **Never capture the image domain-joined** — every clone would share one computer account.
- All static baseline config (security settings, apps, naming) goes in the image.
- USB-Ethernet dongles need a PXE boot ROM; verify per model before buying in bulk.
- Windows Server for the DC needs its own license or eval.

## Domain join

FOG's Active Directory integration (FOG Configuration → HostNameChanger) joins imaged hosts to `ad.<domain>` using a delegated, non-admin join account on the Laptops OU. FOG stores that password encrypted.

## Status

- [x] Phase 0: decisions (Windows 11 Education, mixed Ethernet/dongles, spare NIC port confirmed)
- [x] Phase 1: FOG VM built, both NICs static, GUI reachable, default login changed
- [ ] Phase 2: imaging switch config ([network.md](network.md))
- [ ] Confirm district licensing (Plan A vs B)
- [ ] Build and capture the golden image
- [ ] Test imaging run on a small batch
