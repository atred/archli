#!/bin/bash

# archli, the Arch Linux Lighting Installer
# written by Andrew Redinbo
# licensed under GPLv3

## -------------------- Base install ----------------------  ##

# Set time
timedatectl set-ntp true

# Setup disk
printf "Target drive: /dev/sda\n"
TARGETDRIVE=/dev/sda
printf "Partitioning disk...\n"
swapoff -a
wipefs -qa $TARGETDRIVE
parted --script $TARGETDRIVE \
    mklabel gpt \
    mkpart primary fat32 0% 512MiB \
    mkpart primary linux-swap 512MiB 2560MiB \
    mkpart primary btrfs 2560MiB 100% \
    set 1 esp on
mkfs.vfat ${TARGETDRIVE}1 
mkswap ${TARGETDRIVE}2
mkfs.btrfs -f ${TARGETDRIVE}3
swapon ${TARGETDRIVE}2
mount ${TARGETDRIVE}3 /mnt
mkdir -p /mnt/boot/esp
mount ${TARGETDRIVE}1 /mnt/boot/esp

# Pacstrap main installation
pacstrap /mnt base linux-zen linux-firmware base-devel linux-zen-headers grub os-prober efibootmgr man git neovim ansible networkmanager

# Generate filesystem table
genfstab -U /mnt >> /mnt/etc/fstab

## -------------------- Chroot install --------------------  ##

# Chroot into system
printf "Changing root...\n"
curl -Lo /mnt/archli-chroot.sh https://raw.githubusercontent.com/atred/archli/master/archli-chroot.sh
arch-chroot /mnt /bin/bash ./archli-chroot.sh

# Finish up
printf "Chroot successfully terminated! Cleaning up...\n"
rm /mnt/archli-chroot.sh
umount /mnt/boot/esp
umount /mnt
printf "Cleanup successful! You may now reboot.\n"
