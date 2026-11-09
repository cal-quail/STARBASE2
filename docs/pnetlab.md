# PNETLab: student network labs

Browser-based network labs: students wire routers, switches and firewalls together on a canvas for classes and CyberPatriot practice, without touching the real gear. **Live since October 2026** at `lab.<domain>`.

## Build

| Piece | Detail |
| --- | --- |
| PNETLab VM | Community PNetLab v8 build on node 1, CPU type `host` (nested virtualization; the E5-2670 has VT-x + EPT) |
| Lab gateway VM | Small Ubuntu VM with nftables in front of PNETLab. Lab network → internet only; **no route to any private network**, including the rack LAN |
| Lab network | Its own Proxmox bridge with no physical port |
| Images | Free images only, from the vendors' own sites and boot-tested: VyOS, OPNsense, MikroTik CHR, OpenWrt, Debian, FRR. Cisco images only once licensing (NetAcad / CML) is confirmed |

**Why the fence:** the official PNetLab release is old, runs on an out-of-support OS and caps accounts at 10. The v8 build is from an anonymous community maintainer and isn't vetted, so it gets no access to anything on the rack, and students will be running scans and attacks inside labs anyway.

## Access

`lab.<domain>` → Cloudflare Tunnel → **Authentik** (proxy provider) → lab gateway → PNETLab. The gateway only accepts the published port from the Authentik VM.

- **Header SSO:** after the Authentik login, a small `/sso/` page on PNETLab signs the user in by the username Authentik passes. It only trusts requests from the Authentik VM that carry a shared front-door secret.
- **Account auto-create** is built but **off**. Accounts are created on purpose.
- Choose **HTML5 Console** at the PNETLab login. The native console hands out `telnet://` links to the hidden lab network.

## Students

- The advisor signed off on student accounts (Oct 2026).
- Students get Authentik-only accounts (public sign-up with approval, or invite links), never domain accounts.
- Put students in an **Authentik-only group**. A group synced from AD gets its membership replaced on every sync, which drops Authentik-only members.
- Usernames are limited to letters, digits, `.`, `_` and `-` (3–32 characters), because the SSO page rejects anything else.

## Gotchas

| Problem | Fix |
| --- | --- |
| After SSO, `lab.<domain>` timed out | PNETLab redirected `/` to its internal address. An extra Apache vhost answers for the public name. Don't add `ProxyPassReverse`; it rewrites the redirect back to the internal host |
| Consoles never connected through the tunnel | Turn off HTTP/2 in Apache on the PNETLab VM so websockets work |
| Installer leaves default root logins and password SSH | Undo right after install; key-only SSH |

Re-check both Apache fixes after any PNETLab update.
