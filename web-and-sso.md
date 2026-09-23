# Website hosting and SSO

## Website hosting (planned)

The public site is served from the rack: a small Ubuntu VM on the production segment running **Caddy**, published through the existing **Cloudflare Tunnel**. No inbound ports open; Cloudflare handles TLS at the edge.

- [ ] Create the web VM (1 vCPU / 1–2 GB is plenty for a static site), static IP, 8.8.8.8 / 8.8.4.4 DNS
- [ ] Install Caddy; deploy site files from this repo
- [ ] Cloudflare Zero Trust → tunnel → public hostname `<domain>` → `http://<web-vm-ip>:80`
- [ ] Pick a backend for the compute-request form before it goes live
- [ ] Keep monitoring and admin links internal; only public pages go through the tunnel

Minimal Caddyfile (Cloudflare terminates TLS, so Caddy listens on plain HTTP):

```
:80 {
    root * /var/www/site
    file_server
    encode gzip
}
```

Normal HTTP sites work fine through Cloudflare Tunnel. (Headscale's control handshake was the exception.)

## Single sign-on (evaluating)

One login for rack services instead of separate accounts everywhere. **Authentik** is the option under consideration; not decided yet.

- Would sit in front of Proxmox (OpenID Connect realm), Grafana (OAuth) and the website's request form
- Can pull users and groups from the domain controller over LDAP
- Alternatives to compare: Keycloak (heavier), Authelia (lighter, forward-auth only)
