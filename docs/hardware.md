# Hardware

| Item | Detail |
| --- | --- |
| Router | Cisco ISR 1100 |
| Core switch | Cisco Catalyst WS-C3750E-24TD (24× 1G, 2× 10G X2 uplinks) |
| Servers | 2× Dell PowerEdge R720xd (2U) |
| Storage | 15 TB |
| Memory | 256 GB DDR3 (about 128 GB per server) |
| CPUs | 2× Xeon E5-2670 v1 per server (8 cores / 16 threads each; AVX, no AVX2) |
| RAID controller | PERC H710P Mini (RAID5 across 10 disks) |
| Server NICs | 4-port; one port dedicated to the imaging segment |
| Imaging switches | 2× Cisco CBS250-8FP-E-2G (8-port PoE+, 2× 1G combo uplinks) |
| Management | iDRAC 7 |

Most VMs run on the first server; the second runs the FOG imaging server and the weather simulation.

Service tags and serial numbers are intentionally left out.
