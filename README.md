archli
===

A simple readable shell script that installs Arch Linux on UEFI extremely quickly.
Also installs Ansible and NetworkManager so I can immediately pull my configuration from [here](https://github.com/atred/autodots).

Credit to Luke Smith's [great tutorial video](https://www.youtube.com/watch?v=4PBqpX0_UOc),
[archfi](https://github.com/MatMoul/archfi),
and [spartan-arch](https://github.com/abrochard/spartan-arch) for most of the process.

MAKE SURE TO EDIT DISK PARTITIONING PORTION OF SCRIPT FOR YOUR MACHINE

Note to self: this is the WiFi driver needed for Archer T2U Nano, just `makepkg -si` it like normal.
https://aur.archlinux.org/packages/rtl88xxau-aircrack-dkms-git/

## Install
```
iwctl
device list
station <device> scan
station <device> get-networks
station <device> connect <SSID>
exit
curl -Lo archli.sh redinbo.xyz/archli
vim /etc/pacman.d/mirrorlist
bash archli.sh
```
