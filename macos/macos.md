---
title: macos
categories:
  - software
  - guides
  - notes
  - snippets
author: wandering-mono
url: https://github.com/wandering-mono/snippets.git
---

# macos

- [macos](#macos)
  - [partitioning](#partitioning)
    - [gdisk](#gdisk)
    - [newfs\_type](#newfs_type)

## partitioning

### gdisk

GPT and MBR partitioning tool, clone of linux variant.  
This tool is able to create partitions without useless `EFI` partitions as macOS `Disk Utility` does.  
Can create GPT/MBR table, also can create partition and mark it. Can restore GPT tables.

```sh
sudo gdisk /dev/disk4 # disk4 is external drive for example
```

---

### newfs_type

newfs_apfs  newfs_exfat newfs_hfs  newfs_msdos newfs_udf  
macOS partitioning tools, never used them.
