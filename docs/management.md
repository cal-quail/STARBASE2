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

**Security:** change the default iDRAC password, and keep iDRAC on a management network that isn't exposed to the internet.
