# Roadmap

In order: finish StarDeploy Phase 2, build the golden image, then fleet management, SSO follow-ups, storage and backups, then a security review.

- [ ] StarDeploy Phase 2 switch config ([network.md](network.md))
- [ ] Confirm district licensing (Plan A vs Plan B)
- [ ] Build and capture the golden image; test on 2–3 laptops
- [x] Caddy, publish the site through the tunnel ([web-and-sso.md](web-and-sso.md))
- [x] Backend for the compute request form (local mailer)
- [ ] Build Tactical RMM (or MeshCentral) and bake its agent into the image
- [x] Decide on SSO: **Authentik** with AD as the backbone
- [x] SSO on Proxmox, Grafana, NetBox, Zabbix; Google (link-only) and passkeys; admin passkey MFA
- [ ] SSO for the fan control page, iDRAC (AD login) and PNETLab
- [ ] Friendlier onboarding for new accounts
- [ ] Decide: smaller batches, more switches, or CBS350s
- [ ] Back up, then crossflash an H310 Mini to IT mode and pass it to a TrueNAS VM
- [x] Deploy monitoring: Zabbix + Prometheus + Grafana + NetBox ([monitoring.md](monitoring.md))
- [ ] Monitoring follow-ups: alerts, DC agent, 3750E, off-box backups
- [ ] Backup machine (Proxmox Backup Server) + QDevice for the two-node cluster
- [ ] UPS with clean shutdown
- [ ] PNETLab for student network labs
- [ ] Security review of the rack

## Documentation gaps

- [ ] Storage split per server
- [ ] 3750E license level and VLAN layout
- [ ] ISR 1100 WAN setup and district contact for the uplink
- [x] Proxmox version and clustering (VE 9, two-node cluster)
- [ ] Backup method and schedule
