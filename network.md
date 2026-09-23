# Network

Two segments that are never bridged.

| Segment | Gear | Subnet | Purpose |
| --- | --- | --- | --- |
| Production | ISR 1100 → 3750E → servers | `<prod-subnet>/24` | Management, services, internet (district network) |
| Imaging | 2× CBS250 joined by a LAG | `<imaging-subnet>/24`, FOG at `.1` | PXE, DHCP, TFTP, multicast only; no uplink |

## Rules for the district network

- The district network black-holes **1.1.1.1** (queries time out ~15 s). Use 8.8.8.8 / 8.8.4.4 everywhere — netplan, DC forwarders, DHCP.
- Give every server a static IP (netplan, matched by MAC) before treating its address as fixed. A drifting DHCP lease looks like a firewall problem.
- Admin consoles are never exposed to the internet.

## Imaging switches

CBS250 is a "Smart" switch and **can't stack** (only CBS350 can). Run the two as independent switches joined by a 2-port LAG. That leaves about 13 PoE ports for laptops after the LAG and the FOG uplink.

Phase 2 config per switch:

1. Back up the running config (Administration → File Management → File Operations).
2. Update firmware 3.2.1.1 → 3.5.3.3 (Administration → File Management → Firmware Operations, HTTP/HTTPS), then reboot and verify. Firmware downloads only need a free Cisco.com account.
3. Enable IGMP snooping (multicast).
4. PortFast / RSTP edge on access ports (otherwise PXE times out during STP listening/learning).
5. Configure the LAG between the two switches.
