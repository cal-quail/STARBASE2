# Roadmap

In order: finish StarDeploy Phase 2, build the golden image, stand up the website, then fleet management, SSO, storage and monitoring.

- [ ] StarDeploy Phase 2 switch config ([network.md](network.md))
- [ ] Confirm district licensing (Plan A vs Plan B)
- [ ] Build and capture the golden image; test on 2–3 laptops
- [ ] Web VM + Caddy, publish the site through the tunnel ([web-and-sso.md](web-and-sso.md))
- [ ] Pick a backend for the compute request form
- [ ] Build Tactical RMM (or MeshCentral) and bake its agent into the image
- [ ] Decide on SSO: Authentik vs Keycloak vs Authelia
- [ ] Decide: smaller batches, more switches, or CBS350s
- [ ] Back up, then crossflash an H310 Mini to IT mode and pass it to a TrueNAS VM
- [ ] Deploy Prometheus + Grafana

## Documentation gaps

- [ ] Storage/RAM split per server and which VMs run where
- [ ] 3750E license level and VLAN layout
- [ ] ISR 1100 WAN setup and district contact for the uplink
- [ ] Proxmox version; are the two hosts clustered?
- [ ] Backup method and schedule
