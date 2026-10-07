# Website hosting and SSO

## Website hosting (live)

The public site is served from the rack by **Caddy** on the core services VM (the same VM that runs the Cloudflare Tunnel connector), published through **Cloudflare Tunnel**. No inbound ports are open; Cloudflare handles TLS at the edge. A separate web VM turned out not to be needed for a static site.

- [x] Caddy on the core services VM, static IP, 8.8.8.8 / 8.8.4.4 DNS
- [x] Cloudflare Zero Trust → tunnel → public hostname `<domain>` → `http://<core-vm-ip>:80`
- [x] Compute-request form backend: a small local mailer service behind Caddy
- [ ] Deploy site files from this repo instead of copying them by hand
- [x] Monitoring and admin pages stay internal; only public pages go through the tunnel

Caddyfile outline (Cloudflare terminates TLS, so Caddy listens on plain HTTP):

```
:80 {
    encode gzip zstd
    route {
        @api path */api/*
        reverse_proxy @api 127.0.0.1:<mailer-port>   # compute-request form
        root * /var/www/site
        try_files {path} {path}.html
        file_server
    }
    header {
        X-Content-Type-Options nosniff
        X-Frame-Options DENY
        Referrer-Policy strict-origin-when-cross-origin
        -Server
    }
}
```

Normal HTTP sites work fine through Cloudflare Tunnel. (Headscale's control handshake was the exception.)

## Single sign-on (live)

**Authentik**, with **Active Directory as the backbone**, is the one login for the rack's services. Unlike Cloudflare Access, which only puts a gate in front of an app that still has its own login, every app logs in *through* Authentik (OIDC or SAML). One identity and one set of AD groups decide who gets in and with what role.

| Piece | Detail |
| --- | --- |
| Identity provider | Authentik on its own small VM (Docker Compose), public at `auth.<domain>` through the tunnel. The hostname must never change: passkeys are bound to it |
| User source | AD, synced hourly over **LDAPS** with a read-only service account. Only members of the rack's AD groups are synced |
| LDAPS | AD Certificate Services Enterprise Root CA on the DC; the DC auto-enrolls its certificate |
| AD groups | `SB-Rack-Admins` (admins everywhere), `SB-Rack-Team` (normal access), `SB-PNET-Students` (PNETLab only, later) |
| Sign-in options | AD username + password, **Sign in with Google** (personal accounts, link-only), or a **passkey** |
| Admin MFA | Admins must use a passkey on every login |
| Offboarding | Disabled in AD → disabled in Authentik. Removed from the groups → removed at the next sync. Most apps also re-check roles on each login |
| Break-glass | Authentik keeps a local admin, and every app keeps its own local admin, in case AD or Authentik is down |

### Apps on SSO

| App | Protocol | Admins | Team | Break-glass |
| --- | --- | --- | --- | --- |
| Proxmox VE (both nodes) | OpenID Connect realm | Administrator | PVEAuditor (read-only) | `root@pam` |
| Grafana | Generic OAuth (OIDC) | Admin | Editor | local admin |
| NetBox | OIDC (python-social-auth) | Superuser | View everything | local admin |
| Zabbix | SAML, just-in-time user creation | Super admin | User (read-only) | local Admin |

Still to do: the fan control page, iDRAC (iDRAC 7 has no OIDC/SAML, so AD login over LDAPS), PNETLab, and a friendlier onboarding process.

### Google sign-in: link-only, personal accounts

- Google sign-in only works for a Google account that someone has **linked** to their existing rack account (Settings → Connected services, after one password login). An unlinked Google account gets an explanation page, never a new account, so having Gmail isn't enough to get in.
- Personal Google accounts only. District-managed school accounts aren't used because district settings can block third-party sign-in.
- The Google OAuth app uses only `openid email profile`, so it doesn't need Google's full verification. Publishing it to production still needs a homepage and privacy policy on your own domain, and the app name must appear on the homepage. We serve small about/privacy pages next to Authentik for this.

### Gotchas we hit

- **AD CS install fails with 0x80072082 (ERROR_DS_RANGE_CONSTRAINT):** an Enterprise CA needs **Enterprise Admins**, not just Domain Admins. Sign out and back in after adding the group, remove the half-made CA, re-run.
- **Authentik "Invalid grant_type for provider":** an OIDC provider created through the API can end up with an empty grant types list. Set `authorization_code` and `refresh_token`.
- **NetBox:** the setting is `SOCIAL_AUTH_OIDC_OIDC_ENDPOINT` (OIDC twice), with **no trailing slash**.
- **Zabbix SAML:** users get created but can't log in if their user group's frontend access is "Disabled". Use the system default.
- **Proxmox:** groups from the claim are created as `<group>-<realm>`; create them ahead of time and give them ACLs.
- **"Must change password at next logon"** in AD breaks SSO logins; Authentik can't show that prompt.
- **"Flow does not apply to current user"** when clicking Google while already signed in: set the source authentication flow's authentication requirement to "none".
- Authentik's default self-signed signing key lasts one year. SAML apps pin the certificate, so give them a long-lived key of their own and note when the default one expires.
