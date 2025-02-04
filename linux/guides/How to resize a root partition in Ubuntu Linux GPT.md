# [HOW TO RESIZE A ROOT PARTITION IN UBUNTU (LINUX) (GPT)](https://dade2.net/kb/how-to-resize-a-root-partition-in-ubuntu/)

- [HOW TO RESIZE A ROOT PARTITION IN UBUNTU (LINUX) (GPT)](#how-to-resize-a-root-partition-in-ubuntu-linux-gpt)
  - [Check Disk status with parted command](#check-disk-status-with-parted-command)
  - [Remove Current Partition](#remove-current-partition)
  - [Create and Resize partition with parted](#create-and-resize-partition-with-parted)
  - [Final step settings](#final-step-settings)

**In this article, I will teach you how to resize a root partition on Linux servers. In this scenario, according to which I have prepared the training, it is based on the fact that the partition of hard disk tables is based on GPT patition table and is non-logical (non-LVM) . Also I am teching this Article on Ubunto.
Note that this method may be risky, so I recommend backing up your server data before doing so.**

Warning: Please make a backup of your data before performing these steps. In the event of a mistake or any unforeseen error, your server may not boot again or you may lose your data.

Step-by-step tutorial on resize (increasing) the root partition:

## Check Disk status with parted command

Check current Disk status with gparted. (Run this command: **parted** )

![rrp 1 1 - How to resize a Root Partition in Ubuntu (Linux) (GPT)](./How to resize a root partition in Ubuntu Linux GPT.assets/rrp-1-1.png)

## Remove Current Partition

I want to increase the root partition and the root partition is number two. Therefore, we need to delete the third partition, which is the swap partition, so that we can change the second partition. (Run this command: **rm 3**)

![rrp 2 - How to resize a Root Partition in Ubuntu (Linux) (GPT)](./How to resize a root partition in Ubuntu Linux GPT.assets/rrp-2.png)

As you can see in the image above, the system warns you that the partition is being used by the system. Type **yes**. It also displays the following warning that you must type the Ignore option.
 **Error: Partition(s) 3 on /dev/sda have been written, but we have been unable to inform the kernel of the change, probably because it/they are in use. As a result, the old partition(s) will remain in use. You should reboot now before making further changes. Ignore/Cancel?**

## Create and Resize partition with parted

Now we are going to resize the partition with this command: **resizepart 2

**

the system warns you again :

 Warning: Partition /dev/sda2 is being used. Are you sure you want to continue?
Yes/No?

Type: **Yes**

**End ? 51.7G**
Now the system asks you to specify the final size of the partition. Because we need to re-create the swap partition after the root partition is resized, and I will allocate 2 GB for the swap partition, so I will reduce this amount by 2 GB of space and allocate the rest to the root partition. I have 53.7 GB of space here, the final size I consider for the root partition is 51.7 and the rest will be used to build the swap partition.

 **G is a GIGABYTE symbol and must be entered after entering a numeric value. (Capital letter) If the value is a change of terabytes, use the letter T.**

**Now you got Error Warning :**

 **Error: Partition(s) 3 on /dev/sda have been written, but we have been unable to inform the kernel of the change, probably because it/they are in use. As a result, the old partition(s) will remain in use. You should reboot now before making further changes. Ignore/Cancel?**

**Type: Ignore** (The system may give you this warning several times, each time typing the ignore.)

![rrp 3 - How to resize a Root Partition in Ubuntu (Linux) (GPT)](./How to resize a root partition in Ubuntu Linux GPT.assets/rrp-3.png)

Rebuild the swap partition with this command :

**parted /dev/sda**
**(parted) mkpart**
**Partition name? []?**
**File system type? [ext2]? linux-swap**
**Start? 51.7G**
**End? 53.7G**

The system may give you this warning several times, each time typing the word ignore.

![rrp 4 - How to resize a Root Partition in Ubuntu (Linux) (GPT)](./How to resize a root partition in Ubuntu Linux GPT.assets/rrp-4.png)

## Final step settings

Now Reboot the Server.
After rebooting the server, run the partition resize command: **resize2fs /dev/sda2**

![rrp 5 - How to resize a Root Partition in Ubuntu (Linux) (GPT)](./How to resize a root partition in Ubuntu Linux GPT.assets/rrp-5.png)Before-resize

Now after Resize Partition : **/dev/sda2**

![rrp 6 - How to resize a Root Partition in Ubuntu (Linux) (GPT)](./How to resize a root partition in Ubuntu Linux GPT.assets/rrp-6.png)After-resize

Note that after performing the above steps, because we deleted the swap partition and re-created it, its UUID changes, so it is better to find your swap partition new UUID with the **blkid** command and update it in the **/etc/fstab** file.
