# Roadmap

Last reviewed November 2026.

## Done

- [x] Proxmox two-node cluster (VE 9.2)
- [x] Domain controller; moved to VirtIO and tuned (Nov 2026)
- [x] Public site through Cloudflare Tunnel, compute request form backend ([web-and-sso.md](web-and-sso.md))
- [x] Monitoring: Zabbix + Prometheus + Grafana + NetBox, email alerts ([monitoring.md](monitoring.md))
- [x] SSO with Authentik + AD on Proxmox, Grafana, NetBox, Zabbix, PNETLab; iDRAC AD login; Google (link-only) and passkeys; admin passkey MFA
- [x] Self-service STARBASE accounts with approval, and invite links
- [x] Security review of the rack (Oct 2026) and the first fix phases
- [x] Interim nightly backups with a copy on the second node; restores tested ([storage.md](storage.md))
- [x] PNETLab for student network labs, fenced and behind SSO ([pnetlab.md](pnetlab.md))
- [x] StarDeploy: golden image, one-button imaging, post-image snapin, first laptops imaged and domain-joined ([stardeploy.md](stardeploy.md))
- [x] Laptops on a hosted tailnet with a locked-down policy ([fleet-management.md](fleet-management.md))
- [x] Weather: forecast pipeline, web viewer, live radar and nowcast ([weather.md](weather.md))

## Next

- [ ] Finish domain-joining the current batch; fix clones with MAC-style names
- [ ] Second imaging switch; decide on smaller batches, a third switch, or CBS350s
- [ ] Remote management: Tactical RMM or MeshCentral
- [ ] Proxmox Backup Server + QDevice on a third node; back up node 2's VMs; off-rack copy
- [ ] UPS with clean shutdown
- [ ] Remaining fixes from the security review
- [ ] Fan control page on SSO
- [ ] Monitoring follow-ups: DC agent, core switch, unknown devices, a second alert channel
- [ ] Deploy the website from git instead of by hand
- [ ] Automate weather forecast runs; switch to HRRR
- [ ] Hand off: shared team vault and advisor ownership of the domain, Cloudflare and Google accounts
- [ ] Later: crossflash an H310 Mini to IT mode for a TrueNAS VM (only with backups in place)

## Documentation gaps

- [ ] 3750E license level and VLAN layout
- [ ] ISR 1100 WAN setup and district contact for the uplink
- [ ] Drive count per server
