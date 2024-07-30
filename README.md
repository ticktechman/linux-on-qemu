Setup a linux kernel debug environment for hobbies.

Basic host environment:
- ubuntu-22.04
- gcc-11.4.0
- qemu-6.2.0
- x86-64 intel CPU

What do we need:
- a VM created by qemu 
- a kernel binary image(6.6.43 lastest LTS version)
- a root fs for basic command you needed(busybox-1.36.1)

How to create this environment:

```bash
source mk.sh 

## install host deps software
mk.deps

## download source code of linux kernel and busybox
mk.source.download

## create a rootfs image(ext4) and mount it to root directory
mk.rootfs

## build busybox and install it to root filesystem
mk.busybox 

## build kernel image
mk.kernel

## run a qemu vm based on the kernel image and busybox root filesystem
mk.run
```

> By the way, `Ctrl+a+x` to quit qemu VM.

ENJOY IT.
