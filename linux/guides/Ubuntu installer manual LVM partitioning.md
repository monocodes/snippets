# Ubuntu installer manual LVM partitioning

Alright, I assume that you tried to format and/or mount the 3rd (root) partition. You have to leave it unformatted and unmounted, this way the option for LVM remains.

**NOTE:** When you create the Logical Volumes inside of your Volume Group make sure to format and mount them, otherwise the installer will fail.

At the **Storage Configuration** step, move to **AVAILABLE DEVICES** and make the following changes:

1. Create EFI or BIOS partition; select **Use As Boot Device**.
2. Create boot partition; select **Add GPT Partition**, set the size, format as `ext4` and mount at `/boot`.
3. Create root partition; select **Add GPT Partition**, leave size empty (uses remaining disk space), do **NOT** format and do **NOT** mount (leave unformatted/leave unmounted).
4. Create Volume Group; select **Create volume group (LVM)**, name it and select partition `3` with the checkbox.
5. Create Logical Volume(s); Move to the newly created Volume Group, select **Create Logical Volume**, name it, set size (blank for remaining disk space), format it and mount it.
6. Repeat step 5 for all the Logical Volumes you want to create.
