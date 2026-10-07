# Management (iDRAC 7 + IPMI)

iDRAC 7 handles remote console, power and fan control. Use the **HTML5 virtual console**: the Java console failed on an Apple Silicon Mac with native library errors.

## Enable the HTML5 console

iDRAC web UI → Overview → Server → Virtual Console → Plug-in Type = **HTML5** → Apply.

## Manual fan control

IPMI over LAN must be enabled in iDRAC (iDRAC Settings → Network → IPMI Settings).
The easy way is [`scripts/fan-control.sh`](../scripts/fan-control.sh), which reads credentials from `.env`. The raw commands are:

```bash
# Take manual control
ipmitool -I lanplus -H <idrac-ip> -U <user> -P <pass> raw 0x30 0x30 0x01 0x00
# Set all fans to 20% (0x14 = 20 in hex)
ipmitool -I lanplus -H <idrac-ip> -U <user> -P <pass> raw 0x30 0x30 0x02 0xff 0x14
# Hand control back to iDRAC (do this before heavy loads)
ipmitool -I lanplus -H <idrac-ip> -U <user> -P <pass> raw 0x30 0x30 0x01 0x01
# Check temperatures
ipmitool -I lanplus -H <idrac-ip> -U <user> -P <pass> sdr type temperature
```

Manual fan speed does not ramp up on its own, so watch temperatures while it's set.
Prefer passing the password through the `IPMI_PASSWORD` environment variable with `-E` instead of `-P`, so it doesn't show up in the process list.

## Fan control page

The rack sits in a classroom, so fans have to be quiet during school hours. A small web page (Python standard library + `ipmitool`, bound to localhost on the core services VM and published through the tunnel) lets the teacher set fans without the CLI:

- live temperatures and fan RPM for both servers
- Auto / 20% / 30% / 50% buttons and a 15–100% slider, per server or both
- a weekday schedule (manual 30% in the morning, back to auto in the afternoon)
- re-applies the chosen setting every few minutes, because iDRAC resets to loud auto after a reboot
- failsafe: if a CPU gets too hot on manual, it switches to auto until things cool down

Because the page owns the schedule, don't also run cron fan jobs; they'd fight each other. Today the page sits behind Cloudflare Access; it's moving to the rack's [SSO](web-and-sso.md).

## Read-only monitoring account

Each iDRAC has a separate IPMI user with USER (read-only) privilege for [monitoring](monitoring.md), so the monitoring VM never holds admin credentials.

**Security:** change the default iDRAC password, and keep iDRAC on a management network that isn't exposed to the internet.
