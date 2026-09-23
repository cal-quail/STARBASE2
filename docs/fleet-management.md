# Fleet management

After imaging, the ~80 laptops move to the district production network and **never come back to the rack**. Group Policy only applies when a device can reach the DC, so on-prem AD alone can't manage them.

**Next:** Tactical RMM (agent phones home over HTTPS: remote access, monitoring, patching, inventory). MeshCentral is the lighter alternative. The agent gets baked into the golden image.

**Headscale: dropped.** With only about 80 laptops, a self-hosted tailnet control server isn't worth running. The AD-over-tunnel option is on hold with it.

## Domain controller (done)

- Windows Server VM on the production segment, static IP, DNS pointed at itself.
- AD DS + DNS; new forest `ad.<domain>` — a subdomain, not the public apex, to avoid split-brain DNS. Leave "Create DNS delegation" unchecked.
- Laptops OU; a non-admin join account delegated Create/Delete Computer objects on it (for FOG).
- Test GPO linked and verified. User-side settings (wallpaper) need loopback processing (Merge) because laptops use a local login. A Computer-config logon banner is the simpler demo.
- DNS forwarders: 8.8.8.8 / 8.8.4.4 (not 1.1.1.1).
- Run `dcdiag` from an elevated prompt as a domain admin.
