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
source kenv.sh 

## install host deps software
kenv.deps

## download source code of linux kernel and busybox
kenv.source.download

## create a rootfs image(ext4) and mount it to root directory
kenv.rootfs

## build busybox and install it to root filesystem
kenv.busybox 

## build kernel image
kenv.kernel

## run a qemu vm based on the kernel image and busybox root filesystem
kenv.run
```

> By the way, `Ctrl+a+x` to quit qemu VM.

ENJOY IT.
