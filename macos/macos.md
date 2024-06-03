---
title: macos
categories:
  - software
  - guides
  - notes
  - snippets
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [macos paths](#macos-paths)
  - [`.zshrc`, `.zprofile`](#zshrc-zprofile)
  - [system variables](#system-variables)
- [useful commands](#useful-commands)
  - [users and groups](#users-and-groups)
  - [useful shorcuts](#useful-shorcuts)
  - [apps](#apps)
    - [console apps](#console-apps)
- [network](#network)
- [filesystem](#filesystem)
- [partitioning](#partitioning)
  - [gdisk](#gdisk)
  - [newfs\_type](#newfs_type)
- [macOS guides](#macos-guides)
  - [sed](#sed)
    - [Recursive search and replace in text files on Mac and Linux](#recursive-search-and-replace-in-text-files-on-mac-and-linux)
  - [symlinks](#symlinks)
  - [`PATH` guide](#path-guide)
    - [MacOS Print $PATH Settings](#macos-print-path-settings)
    - [macOS (OS X): Change your PATH environment variable](#macos-os-x-change-your-path-environment-variable)
      - [Method #1: `$HOME/.bash_profile` file to set or change $PATH under macOS](#method-1-homebash_profile-file-to-set-or-change-path-under-macos)
      - [Method #2: `/etc/paths.d` directory](#method-2-etcpathsd-directory)
    - [Conclusion](#conclusion)
      - [See also](#see-also)
  - [How to transfer SD card Nintendo Switch data using macOS by enrogle](#how-to-transfer-sd-card-nintendo-switch-data-using-macos-by-enrogle)

## macos paths

`PATH` variable

```sh
echo $PATH

cat /etc/paths
```

`PATH` files

```sh
ls -lh /etc/paths.d
```

### `.zshrc`, `.zprofile`

`.zshrc`, `.zprofile` locations

```sh
$HOME/.zshrc
$HOME/.zprofile
~/.zshrc
~/.zprofile
```

source `.zshrc`, `.zprofile`

```sh
source $HOME/.zprofile
# or
. $HOME/.zprofile
```

software user configs

```sh
~/.config
```

### system variables

show current environmental variables

```sh
printenv
```

unset var

```sh
unset var-name
# don't forget to check ~/.zprofile and ~/.zshrc

# check results
printenv
```

set `LDFLAGS` and `CPPFLAGS`

```sh
export LDFLAGS="-L/opt/homebrew/opt/libffi/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libffi/include"
```

set multiple `LDFLAGS` and `CPPFLAGS`

```sh
export CPPFLAGS="-I/opt/homebrew/opt/tcl-tk/include -I/opt/homebrew/opt/libffi/include"
export LDFLAGS="-L/opt/homebrew/opt/tcl-tk/lib -L/opt/homebrew/opt/libffi/lib"
```

show active flags

```sh
echo ${LDFLAGS}
echo ${CPPFLAGS}
```

unset flags

```sh
unset LDFLAGS
unset CPPFLAGS
```

---

## useful commands

restart terminal

```sh
exec zsh -l
```

show help for BSD command

```sh
man command-name
man sed
```

show help for GNU command

```sh
command-name --help
```

clear zsh history of current session

```sh
history -p
```

---

### users and groups

list all users

```sh
dscl . list /users
```

list all groups

```sh
dscl . list /groups
```

### useful shorcuts

show dotfiles in Finder

```properties
Cmd + Shift + Dot
```

smiles menu in any text editor<!--  -->

```properties
Cmd + Ctrl + Space
```

### apps

**Google Chrome**

disable two-finger back/forward navigation in Chrome

```sh
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool FALSE

# restart chrome
chrome://restart
```

**Vivaldi**

disable two-finger back/forward navigation in Vivaldi

```sh
defaults write com.vivaldi.Vivaldi AppleEnableSwipeNavigateWithScrolls -bool FALSE
```

**Time Machine**

Time Machine settings

```sh
/Library/Preferences/com.apple.TimeMachine.plist
```

to edit com.apple.TimeMachine.plist

1) `cp` it anywhere

2) edit it with xml editor or xcode

3) copy file back

   ```sh
   sudo cp com.apple.TimeMachine.plist /Library/Preferences/
   ```

**Terminal**

switch between tabs

```sh
Ctrl + Tab # forward
Ctrl + Shift + Tab # backward
```

---

#### console apps

**grep**

make `grep` colorful in macOS

```sh
vim ~/.zprofile

export GREP_OPTIONS='--color=auto'

source ~/.zprofile
```

**vim**

turn on syntax highlighting in vim

```sh
echo "syntax on" >> ~/.vimrc
```

---

## network

flush dns

```sh
sudo killall -HUP mDNSResponder
sudo killall -HUP mDNSResponder; sleep 2; echo macOS DNS Cache Reset | say
```

show arp table

```sh
arp -a
```

delete cache for interface

```sh
sudo arp -d 192.168.1.10 ifscope en0
```

clear all arp cache

```sh
sudo arp -a -d
```

show network path to the server and diagnose latency problems

```sh
traceroute google.com
```

add second IP address to an existing network adapter  
non-persistent, will be deleted after reboot

```sh
sudo ifconfig en0 alias 192.168.10.5/24 up
```

remove alias

```sh
sudo ifconfig en0 -alias 192.168.10.5
```

---

## filesystem

`fs_usage`

The file system usage tool is ideal since it taps in to the real time file system events and dumps activity to a file or the screen. Since you know the exact path of the file, you can filter out all the thousands of irrelevant (to this case) filesystem changes and see what reads / writes to that file pretty quickly.

```sh
sudo fs_usage | grep /Users/me/aa
```

---

## partitioning

### gdisk

GPT and MBR partitioning tool, clone of linux variant.  
This tool is able to create partitions without useless `EFI` partitions as macOS `Disk Utility` does.  
Can create GPT/MBR table, also can create partition and mark it. Can restore GPT tables.

```sh
sudo gdisk /dev/disk4 # disk4 is external drive for example
```

### newfs_type

macOS partitioning tools, never used them.

- newfs_apfs
- newfs_exfat
- newfs_hfs
- newfs_msdos
- newfs_udf

---

### macOS ExFAT GUID external disk without EFI partition - guide

By default macOS **Disk Utility** creates GUID partitions with hidden EFI partition. For external hard drive you don't need this partition. It's the best way to create GUID table with ExFAT partition

- Launch Terminal

- Check the physical drives and choose that you want to format

  ```sh
  diskutil list
  ```

  - example - `disk4` here is the external USB drive

    ```sh
    mono@mono-mac /dev % diskutil list
    /dev/disk0 (internal, physical):
       #:                       TYPE NAME                    SIZE       IDENTIFIER
       0:      GUID_partition_scheme                        *1.0 TB     disk0
       1:             Apple_APFS_ISC Container disk1         524.3 MB   disk0s1
       2:                 Apple_APFS Container disk3         994.7 GB   disk0s2
       3:        Apple_APFS_Recovery Container disk2         5.4 GB     disk0s3
    
    /dev/disk3 (synthesized):
       #:                       TYPE NAME                    SIZE       IDENTIFIER
       0:      APFS Container Scheme -                      +994.7 GB   disk3
                                     Physical Store disk0s2
       1:                APFS Volume Macintosh HD - Data     519.9 GB   disk3s1
       2:                APFS Volume Macintosh HD            10.3 GB    disk3s3
       3:              APFS Snapshot com.apple.os.update-... 10.3 GB    disk3s3s1
       4:                APFS Volume Preboot                 6.2 GB     disk3s4
       5:                APFS Volume Recovery                937.8 MB   disk3s5
       6:                APFS Volume VM                      5.4 GB     disk3s6
    
    /dev/disk4 (external, physical):
       #:                       TYPE NAME                    SIZE       IDENTIFIER
       0:      GUID_partition_scheme                        *1.0 TB     disk4
    ```

- Launch `gdisk`, format the drive with GUID and create partition

  ```sh
  sudo gdisk /dev/disk4
  
  # example when we have normal GUID partition
  mono@mono-mac /dev % sudo gdisk /dev/disk4
  GPT fdisk (gdisk) version 1.0.10
  
  Partition table scan:
    MBR: protective
    BSD: not present
    APM: not present
    GPT: present
  
  Found valid GPT with protective MBR; using GPT.
  
  ```

- `o` - create a new empty GUID partition table (GPT)

- `n` - add a new partition

  ```sh
  Command (? for help): n
  Partition number (1-128, default 1): # Enter
  First sector (34-1953525134, default = 2048) or {+-}size{KMGTP}: # Enter
  Last sector (2048-1953525134, default = 1953523711) or {+-}size{KMGTP}: # Enter
  Current type is AF00 (Apple HFS/HFS+)
  Hex code or GUID (L to show codes, Enter = AF00): 0700
  
  # Check with p that everything us fine
  Command (? for help): p
  Disk /dev/disk4: 1953525168 sectors, 931.5 GiB
  Sector size (logical): 512 bytes
  Disk identifier (GUID): 0FA5201C-E760-4BB5-BFE9-15BF25697C7A
  Partition table holds up to 128 entries
  Main partition table begins at sector 2 and ends at sector 33
  First usable sector is 34, last usable sector is 1953525134
  Partitions will be aligned on 2048-sector boundaries
  Total free space is 3437 sectors (1.7 MiB)
  
  Number  Start (sector)    End (sector)  Size       Code  Name
     1            2048      1953523711   931.5 GiB   0700  Microsoft basic data
  ```

- `w` - write table to disk and exit

- Check with `diskutil list` that everything is fine

  ```sh
  mono@mono-mac /dev % diskutil list
  /dev/disk0 (internal, physical):
     #:                       TYPE NAME                    SIZE       IDENTIFIER
     0:      GUID_partition_scheme                        *1.0 TB     disk0
     1:             Apple_APFS_ISC Container disk1         524.3 MB   disk0s1
     2:                 Apple_APFS Container disk3         994.7 GB   disk0s2
     3:        Apple_APFS_Recovery Container disk2         5.4 GB     disk0s3
  
  /dev/disk3 (synthesized):
     #:                       TYPE NAME                    SIZE       IDENTIFIER
     0:      APFS Container Scheme -                      +994.7 GB   disk3
                                   Physical Store disk0s2
     1:                APFS Volume Macintosh HD - Data     520.3 GB   disk3s1
     2:                APFS Volume Macintosh HD            10.3 GB    disk3s3
     3:              APFS Snapshot com.apple.os.update-... 10.3 GB    disk3s3s1
     4:                APFS Volume Preboot                 6.2 GB     disk3s4
     5:                APFS Volume Recovery                937.8 MB   disk3s5
     6:                APFS Volume VM                      5.4 GB     disk3s6
  
  /dev/disk4 (external, physical):
     #:                       TYPE NAME                    SIZE       IDENTIFIER
     0:      GUID_partition_scheme                        *1.0 TB     disk4
     1:       Microsoft Basic Data                         1.0 TB     disk4s1
  ```

- Format created partition to ExFAT

  ```sh
  sudo newfs_exfat /dev/disk4s1
  
  # example
  mono@mono-mac /dev % sudo newfs_exfat /dev/disk4s1
  Reformatting existing ExFAT volume
  Partition offset : 2048 sectors (1048576 bytes)
  Volume size      : 1953521664 sectors (1000203091968 bytes)
  Bytes per sector : 512
  Bytes per cluster: 131072
  FAT offset       : 2048 sectors (1048576 bytes)
  # FAT sectors    : 61440
  Number of FATs   : 1
  Cluster offset   : 63488 sectors (32505856 bytes)
  # Clusters       : 7630696
  Volume Serial #  : 6659abcd
  Bitmap start     : 2
  Bitmap file size : 953837
  Upcase start     : 10
  Upcase file size : 5836
  Root start       : 11
  ```

  - if you get Resource busy

    ```sh
    mono@mono-mac /dev % sudo newfs_exfat /dev/disk4s1
    newfs_exfat: /dev/disk4s1: Resource busy
    
    # Forcefully unmount the drive
    sudo diskutil unmountDisk force /dev/disk4s1
    
    mono@mono-mac /dev % sudo diskutil unmountDisk force /dev/disk4s1
    Forced unmount of all volumes on disk4 was successful
    ```

- Eject and turn on the hard drive

- You can check the hard drive in macOS Disk Utility and rename the partition as you want

---

## macOS guides

### sed

use `sed` from macOS or use `gsed` from GNU

```sh
brew install gsed
```

find text in files recursively and change it

```sh
LC_ALL=C find . -type f -name 'filename-regex' -exec sed -i '' s/word-to-replace/word-that-replace/g {} +

# example
LC_ALL=C find . -type f -name '*' -exec sed -i '' s/venv-data_vis/venv-data-vis/g {} +
```

#### [Recursive search and replace in text files on Mac and Linux](https://stackoverflow.com/questions/9704020/recursive-search-and-replace-in-text-files-on-mac-and-linux)

OS X uses a mix of BSD and GNU tools, so best always check the documentation (although I had it that `less` didn't even conform to the OS X manpage):

<https://web.archive.org/web/20170808213955/https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/sed.1.html>

sed takes the argument after `-i` as the extension for backups. Provide an empty string (`-i ''`) for no backups.

The following should do:

```sh
find . -type f -name '*.txt' -exec sed -i '' s/this/that/g {} +
```

The `-type f` is just good practice; sed will complain if you give it a directory or so.

`-exec` is preferred over `xargs`; you needn't bother with `-print0` or anything.

The `{} +` at the end means that `find` will append all results as arguments to one instance of the called command, instead of re-running it for each result. (One exception is when the maximal number of command-line arguments allowed by the OS is breached; in that case `find` will run more than one instance.)

If you get an error like "invalid byte sequence," it might help to force the standard locale by adding `LC_ALL=C` at the start of the command, like so:

```sh
LC_ALL=C find . -type f -name '*.txt' -exec sed -i '' s/this/that/g {} +
```

---

### symlinks

**Remove Python symbolic links example**

The symlinks referencing Python frameworks are in the `/usr/local/bin` directory. If you would like to see the broken symlinks, please use the following command.

1. become root

   ```sh
   sudo -i
   ```

2. check symlinks first

   ```sh
   ls -l /usr/local/bin | grep '../Library/Frameworks/Python.framework'
   ```

3. delete symlinks

   ```sh
   ls -l /usr/local/bin | grep '../Library/Frameworks/Python.framework' | awk '{print $9}' | tr -d @ | xargs rm
   ```

4. check symlinks again

   ```sh
   ls /usr/local/bin
   ```

---

### `PATH` guide

[MacOS – Set / Change $PATH Variable Command](https://www.cyberciti.biz/faq/appleosx-bash-unix-change-set-path-environment-variable/)

| Tutorial details  |                                                              |
| :---------------: | ------------------------------------------------------------ |
| Difficulty level  | [Easy](https://www.cyberciti.biz/faq/tag/easy/)              |
|  Root privileges  | No                                                           |
|   Requirements    | macOS terminal                                               |
|     Category      | [Linux shell scripting](https://bash.cyberciti.biz/guide/Main_Page) |
|   Prerequisites   | Apple macOS/OS X with bash                                   |
| OS compatibility  | BSD • [Linux](https://www.cyberciti.biz/faq/category/linux/) • [macOS](https://www.cyberciti.biz/faq/category/mac-os-x/) • OS X • [Unix](https://www.cyberciti.biz/faq/category/unix/) |
| Est. reading time | 4 minutes                                                    |

[$PATH is nothing but an environment variable on Linux, OS X, Unix-like](https://bash.cyberciti.biz/guide/Variables#Commonly_Used_Shell_Variables) operating systems, and Microsoft Windows. You can specify a set of directories where executable programs are located using $PATH. The $PATH variable is specified as a list of directory names separated by colon (:) characters.

#### MacOS Print $PATH Settings

To print the current settings, open the Terminal application and then [printf command](https://bash.cyberciti.biz/guide/Printf_command) or [echo command](https://bash.cyberciti.biz/guide/Echo_Command)

```sh
echo "$PATH"
```

OR

```sh
printf "%s\n" $PATH
```

Here is what I see

```sh
echo "$PATH"

# Output
/opt/homebrew/Cellar/pyenv-virtualenv/1.2.1/shims:/Users/mono/.pyenv/shims:/Users/mono/Documents/code/apps/apache-maven-3.9.0/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/VMware Fusion.app/Contents/Public:/Library/Apple/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin
```

```sh
printf "%s\n" $PATH

# Output
/opt/homebrew/Cellar/pyenv-virtualenv/1.2.1/shims:/Users/mono/.pyenv/shims:/Users/mono/Documents/code/apps/apache-maven-3.9.0/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/VMware Fusion.app/Contents/Public:/Library/Apple/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin
```

#### macOS (OS X): Change your PATH environment variable

You can add path to any one of the following method:

1. `$HOME/.bash_profile` file using export syntax.
2. `/etc/paths.d` directory.

##### Method #1: `$HOME/.bash_profile` file to set or change $PATH under macOS

1. Open the Terminal app on macOS

2. The syntax is as follows using the [export command](https://www.cyberciti.biz/faq/linux-unix-shell-export-command/) to add to the PATH on macOS:

   ```sh
   export PATH=$PATH:/new/dir/location1
   export PATH=$PATH:/new/dir1:/dir2:/dir/path/no3
   ```

3. In this example, add the /usr/local/sbin/modemZapp/ directory to $PATH variable. Edit the file `$HOME/.bash_profile`, enter:

   ```sh
   vi $HOME/.bash_profile
   # or
   nano ~/.bash_profile
   ```

4. Append the following export command:

   ```sh
   export PATH=$PATH:/usr/local/sbin/modemZapp
   ```

5. [Save and close the file](https://www.cyberciti.biz/faq/linux-unix-vim-save-and-quit-command/) when using vim/vi as a text editor. Then, to apply changes immediately enter the following [source command](https://bash.cyberciti.biz/guide/Source_command):

   ```sh
   source $HOME/.bash_profile
   # or
   . $HOME/.bash_profile
   ```

6. Finally, verify your new path settings, enter:

   ```sh
   echo "$PATH"
   ```

   Sample outputs:

   ```sh
   /usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin:/usr/local/sbin/modemZapp
   ```

##### Method #2: `/etc/paths.d` directory

Apple recommends the path_helper tool to generate the PATH variable i.e. helper for constructing PATH environment variable. From the man page:

> The path_helper utility reads the contents of the files in the directories **/etc/paths.d** and **/etc/manpaths.d** and appends their contents to the PATH and MANPATH environment variables respectively.
>
> (The MANPATH environment variable will not be modified unless it is already set in the environment.)
>
> Files in these directories should contain one path element per line.
>
> Prior to reading these directories, default PATH and MANPATH values are obtained from the files **/etc/paths** and /etc/manpaths respectively.

To list existing path, enter:

```sh
ls -l /etc/paths.d/
```

Sample outputs:

```sh
total 16
-rw-r--r--  1 root  wheel  13 Sep 28  2012 40-XQuartz
```

You can use the cat command to see path settings in 40-XQuartz:

```sh
cat /etc/paths.d/40-XQuartz
```

Sample outputs:

```sh
/opt/X11/bin
```

To set /usr/local/sbin/modemZapp to $PATH, enter:

```sh
sudo -s 'echo "/usr/local/sbin/modemZapp" > /etc/paths.d/zmodemapp'
```

OR use vi text editor as follows to create /etc/paths.d/zmodemapp file:

```sh
sudo vi /etc/paths.d/zmodemapp
```

and append the following text:

```sh
/usr/local/sbin/modemZapp
```

Save and close the file. You need to reboot the system. Alternatively, you can close and reopen the Terminal app to see new $PATH changes.

#### Conclusion

MacOS Set or Change $PATH settings:

1. Use the [.bash_profile](https://bash.cyberciti.biz/guide/.bash_profile) file when you need to generate the PATH variable for a single user account.
2. Use the `/etc/paths.d/` directory or folder via the path_helper command tool to generate the PATH variable for all user accounts on the system. This method only works on OS X Leopard and higher macOS version.

See the following manual pages using the [help command](https://bash.cyberciti.biz/guide/Help_command) or [man command](https://bash.cyberciti.biz/guide/Man_command) on your macOS / OS X machine:

```sh
man bash
man path_helper
help export
```

##### See also

- [Customize the bash shell environments](https://bash.cyberciti.biz/guide/Customize_the_bash_shell_environments) from the Linux shell scripting wiki.
- [$PATH variable](https://bash.cyberciti.biz/guide/$PATH)
- [UNIX: Set Environment Variable](https://www.cyberciti.biz/faq/set-environment-variable-unix/)

**About the author:** Vivek Gite is the founder of nixCraft, the oldest running blog about Linux and open source. He wrote more than 7k+ posts and helped numerous readers to master IT topics.

---

### [How to transfer SD card Nintendo Switch data using macOS](https://www.reddit.com/r/NintendoSwitch/comments/emjvdf/how_to_transfer_sd_card_data_using_macos/) by enrogle

If you're using windows, just follow [Nintendo's advice](https://en-americas-support.nintendo.com/app/answers/detail/a_id/27595/~/how-to-transfer-data-between-microsd-cards-for-use-on-nintendo-switch), but if you're using macOS / OSX you end up with annoying error messages telling you your card is corrupt. It took me ages to figure this out, so I thought I'd share. I read [this post](https://www.reddit.com/r/NintendoSwitch/comments/9s7ljc/save_you_time_copying_sd_card_on_mac_does_not_work/) and was convinced it might not be possible, but I just upgraded my 128GB card to a 256GB without losing (or having to re-download) any content. Hope this helps someone here.

Steps are as follows:

1. Backup the Nintendo folder from your original SD card. You can just drag and drop it to your Desktop, but just to be on the safe side I ran **Disk Utility** and selected **File -> New Image -> Image from "disk2s1"**. Your SD card may be named differently.
2. Format the new SD card in the Switch
3. Eject the old SD card and insert the new SD card into your mac
4. Copy *contents* of the Nintendo folder from your copy onto the new SD card (if you did it via an image, then double-click on your image file to mount it, then copy from there). Select *Replace all files* if prompted.
5. Wait for ages for the data to copy...
6. Close all Finder windows then run **Terminal**
7. From the Terminal, run the following commands (After formatting my SD card was called "Untitled", if yours isn't called then, then adjust accordingly). These commands will require your admin password.

```sh
    sudo chflags -R arch /Volumes/Untitled/
    sudo chflags -R noarch /Volumes/Untitled/Nintendo/
    sudo mdutil -i off /Volumes/Untitled/
    sudo mdutil -E /Volumes/Untitled/
    dot_clean -m /Volumes/Untitled/
```

You're now done, eject the SD card and it should work in the Switch.

If you want to know what the commands do, in order they:

- Set the archive bit ON for the SD Card
- Set the archive bit OFF for the Nintendo folder
- Stop macOS from indexing the SD Card
- Removes hidden files added by Finder
- Another way to remove hidden files added by Finder - running both won't cause any harm

---

### [MacBook Battery drains quickly post Sonoma update](https://discussions.apple.com/thread/255454132?answerId=260424610022&sortBy=best#260424610022)

macOS Sonoma has drained battery problem

To fix that I found post:

Hello all,

I've been busying myself away for a while trying to debug the issue and/or find a cure for the issue.

#### TL;DR; QUICK "SOLUTION" 

Open a Terminal and type 

```sh
sudo pmset -a hibernatemode 25
```

I have been problem free for over a week now. The battery does still drain a little bit, e.g. 5-10%, but that's acceptable to me.

I hope this continues to work and I also hope it works for you as well 🤞

#### LONG STORY

As it stands I have tried a LOT of things and none of them worked:

- Disable "Allow Handoff between this Mac and your iCloud devices"
- Disable Wifi
- Disable Bluetooth
- Remove all background items
- Disable all battery settings from System Prefs -> Battery -> Options (Slightly dim display... (Off) , Enable power nap (Never), Put hard disks to sleep (Always), Wake for Network Access (Never)
- Disable hidden power management settings using pmset: ttyskeepawake=0, tcpkeepalive=0, proximitywake=0, womp=0
- Removing all Google products (including Chrome) and ensuring all background tasks (launchagents/launchdaemons) were uninstalled. Reason for this is that lots of people report Google updater being a sleep preventer. ASIDE: I've officially been an Edge user for 2 weeks now 🤯
- I have tried using the SleepAid app. Alas this effectively crashes when the battery dies. It doesn't have the ability to diagnose this specific issue.
- Removed as many possible apps and other garbage from my Mac as possible
- Tried sleeping with the laptop lid open
- Tried sleeping using software, e.g. the Apple menu -> sleep
- Confirmed that there's nothing in Activity Monitor marked as "Preventing Sleep" other than WindowServer (which I believe is normal when you are using the Mac)

The only useful place I can get information from is using the system logs from the Console.app. If you filter by the keyword "PMRD" then you can see all power related messaging.

I have even spent time debugging the kernel using DTrace and the source code for the XNU kernel

It's worth noting that I can definitely see differences between logs when the problem occurs and when it doesn't. It seems to me that sometimes when you try to sleep, something goes wrong right at the moment of trying to sleep your laptop (e.g. when you close the lid). In other words, your battery’s fate is sealed from the moment you try to sleep. The annoying part is that it's impossible to check if this happened without unsleeping the mac. If you observe the problem, you change it and thus have to sleep again (a Heisenbug).

##### Other observations:

- (I think someone else mentioned this) When the problem occurs, if you try to wake your mac up with the keyboard then it won't wake. You need to press the power button to wake it back up. Normally, a key press alone should wake it up.
- Apple changed power management code in the XNU kernel for Sonoma. There was nothing obvious that could explain the issue off hand, but I strongly feel that this is a software bug in the kernel rather than some hardware fault or some bad state our Macs are in. Seems like a race condition in the sleep logic where a driver says "hey, I can't sleep". Sometimes that happens at a good time and sleep still occurs, other times it doesn't.

##### hibernatemode

Anyway, silliness aside, what is hibernatemode all about?

macOS has 3 hibernate modes 0, 3 and 25 (weird numbering right?):

- `0`: Sleep everything but leave your RAM powered on
- `3`: Sleep everything, leave your RAM powered on but also backup RAM to disk in case of a power failure
- `25`: Sleep everything including RAM. Copy RAM contents to disk then power off RAM as well.

The only impact of switching to mode 25 is that your mac isn't as snappy when you wake it up. It takes a second or two to respond. This however is a worthwhile price to pay given your battery won't be dead every morning.

#### CONCLUSION

This is not a fix, it's a workaround. God knows if Apple will ever fix this (or even acknowledge it).

If the issue comes back again then I have a handful of ideas for other things to try, but frankly I'm close to being out of options. Keeping my fingers crossed this works.

Even if this works for you, can I recommend that everyone submits a bug report via Feedback Assistant please (if you haven't already)? Do it the morning after a battery death - so you'll need to set hibernatemode back to 3 to do that. I'd suggest linking to this post in the bug report.

Beyond that, I might take my Mac to the Apple store but I'm expecting to be told it's due to water damage and I need to spend $1000 on a new motherboard 😂😢

Beyond that, the only other thing I can suggest is that we start methodically capturing how many of us have the issue and see if there's enough people to pressure Apple or even consider threatening with class action. I'm not hopeful though.

---
