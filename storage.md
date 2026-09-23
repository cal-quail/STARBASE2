# Storage

One RAID5 virtual disk across all 10 drives on the PERC H710P, imported from a previous configuration. RAID5 survives one drive failure; a second failure during a rebuild loses the array, so keep backups off-box.

## Foreign Configuration fix (done)

The H710P flagged the existing array as a foreign configuration. It was resolved by importing it, not clearing it.

1. Boot and press **Ctrl+R** to enter the PERC configuration utility.
2. On the controller, open **Foreign Config** and choose **Import**. (**Clear** wipes the array metadata.)
3. Confirm the virtual disk shows **Optimal**, then exit and reboot.
