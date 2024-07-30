#!/usr/bin/env bash
###############################################################################
##
##       filename: a.sh
##    description:
##        created: 2024/07/29
##         author: ticktechman
##
###############################################################################

MK_DIR="$(pwd)"
echo "mk: we will build kernel environment under: ${MK_DIR} "

function mk() {
  cd "${MK_DIR}"
}

function mk.deps() {
  echo "==> start installing deps ..." &&
    sudo apt update &&
    sudo apt install -y git wget &&
    sudo apt install -y build-essential flex bison libssl-dev libelf-dev libncurses-dev bc file &&
    sudo apt install -y qemu-system-x86 &&
    echo "==> succ" || echo "==> failed"
}

function mk.source.download() {
  echo "==> start donwloading source code of linux kernel and busybox ..." &&
    wget https://mirrors.tuna.tsinghua.edu.cn/kernel/v6.x/linux-6.6.43.tar.xz &&
    wget https://busybox.net/downloads/busybox-1.36.1.tar.bz2 &&
    echo "==> succ" || echo "==> failed"
}

function mk.kernel() {
  echo "==> build kernel ..." &&
    cd "${MK_DIR}" &&
    tar Jxf linux-6.6.43.tar.xz &&
    cd linux-6.6.43 &&
    make defconfig &&
    make -j4 &&
    echo "==> succ" || echo "==> failed"
}

function mk.busybox() {
  echo "==> build busybox ..." &&
    cd "${MK_DIR}" &&
    tar jxvf busybox-1.36.1.tar.bz2 &&
    cp ./busybox-qemu-defconfig busybox-1.36.1/.config &&
    cd busybox-1.36.1 &&
    make -j4 &&
    sudo make CONFIG_PREFIX=${MK_DIR}/root install &&
    echo "==> succ" || echo "==> fail"
}

function mk.rootfs() {
  echo "==> make rootfs ..." &&
    cd "${MK_DIR}" &&
    dd if=/dev/zero of=root.img bs=1M count=16 &&
    mkfs.ext4 -F root.img &&
    mkdir root &&
    sudo mount -t ext4 -o loop root.img root &&
    mk.script &&
    sudo mkdir -p root/{root,proc,sys,dev,etc,etc/init.d} &&
    sudo mv rcS root/etc/init.d/ &&
    sudo chmod u+x root/etc/init.d/rcS &&
    sudo mv profile fstab root/etc/ &&
    sudo chown -R root:root root/* &&
    echo "==> succ" || echo "==> fail"
}

function mk.script() {
  cat >rcS <<!EOF
#! /bin/sh
/bin/mount -a
mount -o remount,rw /
!EOF

  cat >fstab <<!EOF
proc		/proc	proc	defaults    0	0
sysfs		/sys	sysfs	defaults    0	0
debugfs		/sys/kernel/debug	debugfs	defaults    0	0
!EOF

  cat >profile <<!EOF
export HOME=/root
alias cls=clear
alias ll='ls -l'
alias la='ls -lA'
!EOF
}

function mk.clean() {
  [[ -d ${MK_DIR}/root ]] && sudo umount ${MK_DIR}/root
  rm -rf root root.img
  rm -rf busybox-1.36.1
  rm -rf linux-6.6.43
}

function mk.run() {
  sudo qemu-system-x86_64 -m 128 -kernel linux-6.6.43/arch/x86_64/boot/bzImage -hda ./root.img -append "root=/dev/sda init=/bin/busybox init console=ttyS0" --nographic
}

###############################################################################
