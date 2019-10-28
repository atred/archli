#!/bin/bash

# archli, the Arch Linux Lighting Installer
# written by Andrew Redinbo
# licensed under GPLv3

## -------------------- Base install --------------------  ##

# Set time
timedatectl set-ntp true

# Setup disk
read -p "Target drive: " targetDrive
printf "Partitioning disk...\n"
parted --script $targetDrive \
    mklabel gpt \
    mkpart primary fat32 0% 512MiB \
    mkpart primary linux-swap 512MiB 4608MiB \
    mkpart primary ext4 4608MiB 100% \
    set 1 esp on
mkfs.vfat /dev/sda1 
mkswap /dev/sda2
mkfs.ext4 /dev/sda3
swapon /dev/sda2
mount /dev/sda3 /mnt
mkdir -p /mnt/boot/esp
mount /dev/sda1 /mnt/boot/esp

# Pacstrap main installation
pacstrap /mnt base linux linux-firmware base-devel grub efibootmgr man git vim ansible networkmanager

# Generate filesystem table
genfstab -U /mnt >> /mnt/etc/fstab

## -------------------- Chroot install --------------------  ##

# Chroot into system
printf "Changing root...\n"
wget https://raw.githubusercontent.com/atred/archli/master/archli-chroot.sh -O /mnt/archli-chroot.sh
arch-chroot /mnt /bin/bash ./archli-chroot.sh $user $pass $host

# Finish up
printf "Chroot successfully terminated! Cleaning up...\n"
rm /mnt/archli-chroot.sh
umount /mnt/boot/esp
umount /mnt
printf "Cleanup successful! You may now reboot.\n"
