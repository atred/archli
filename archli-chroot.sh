#!/bin/bash

# TODO: Set up mirrors using reflector
# printf "Setting up mirrors...\n"

# Timezone
printf "Setting timezone...\n"
timedatectl set-ntp true
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
timedatectl set-timezone America/New_York
hwclock --systohc

# Locale
printf "Setting locale...\n"
sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

# Hostname
read -p "Create hostname: " host
echo $host > /etc/hostname

# Install bootloader
printf "Installing GRUB2 for UEFI...\n"
grub-install --target=x86_64-efi --efi-directory=/boot/esp --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg

# Enable periodic trim and network services
printf "Enabling services...\n"
systemctl enable fstrim.timer
systemctl enable NetworkManager.service

# Manage users
printf "Managing users...\n"
# Create user
read -p "Create username: " user
useradd -m -G wheel,sudo -s /bin/bash $user
# Set user password
passwd $user
# Remove root password
printf "Removing the root password...\n"
passwd -l root

# Exit chroot
printf "Exiting chroot...\n"
