# Storage and backups

Each server has its own RAID5 virtual disk on its PERC H710P (600 GB 10K SAS drives, about 15 TB across both). RAID5 survives one drive failure; a second failure during a rebuild loses the array, so backups matter.

## Backups (interim, since October 2026)

- **Nightly Proxmox backup job** at 01:00: every VM on node 1 (DC, core services, monitoring, SSO, lab gateway, PNETLab), snapshot mode, zstd, keeping 7 daily + 4 weekly.
- Written to a dedicated backup volume on node 1, then **copied to node 2** by a vzdump hook over the cluster's own SSH trust, so losing one server doesn't lose the backups.
- **Restores are tested.** The SSO VM was restored to an isolated VM in October, and the DC was restored for real in November (see [troubleshooting.md](troubleshooting.md)).
- A backup run by hand counts toward "keep daily", so it replaces that day's nightly backup. Mark it **protected** if it has to be kept.

Gaps: node 2's own VMs (FOG, weather) aren't backed up yet, the node 1 backup volume is nearly full, nothing is off-rack, and failed backups don't alert anyone. **Plan:** Proxmox Backup Server on a third node with about 5 TB, which will also host the cluster's QDevice.

## Foreign Configuration fix (done)

The H710P flagged the existing array as a foreign configuration. It was resolved by importing it, not clearing it.

1. Boot and press **Ctrl+R** to enter the PERC configuration utility.
2. On the controller, open **Foreign Config** and choose **Import**. (**Clear** wipes the array metadata.)
3. Confirm the virtual disk shows **Optimal**, then exit and reboot.
