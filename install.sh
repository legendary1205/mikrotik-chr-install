#!/bin/bash

clear
echo -e "\e[96m"
echo "██████╗  █████╗ ██████╗ ██╗██████╗  ██████╗     ███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗ "
echo "██╔══██╗██╔══██╗██╔══██╗██║██╔══██╗██╔═══██╗    ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗"
echo "██████╔╝███████║██████╔╝██║██║  ██║██║   ██║    ███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝"
echo "██╔══██╗██╔══██║██╔═══╝ ██║██║  ██║██║   ██║    ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗"
echo "██║  ██║██║  ██║██║     ██║██████╔╝╚██████╔╝    ███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║"
echo "╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝  ╚═════╝     ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝"
echo -e "\e[0m"
echo ""
echo "1) Install MikroTik (Automatic)"
echo "2) Install MikroTik (Custom)"
echo "3) Exit"
echo ""
read -p "Select option [1-3]: " MENU

ask_interface() {
    echo ""
    echo "Available interfaces:"
    ip -o link show | awk -F': ' '{print " - " $2}'
    echo ""
    read -p "Enter your Network Interface (e.g. eth0, ens3): " IFACE
}

ask_disk() {
    echo ""
    echo "Available disks:"
    lsblk -d -o NAME,SIZE
    echo ""
    read -p "Enter your Disk Name (e.g. vda, sda): " DISK
}

confirm() {
    echo ""
    read -p "Are you sure you want to install MikroTik? (yes/no): " ANSW
    if [[ "$ANSW" != "yes" ]]; then
        echo "Installation canceled."
        exit 0
    fi
}

if [[ "$MENU" == "3" ]]; then
    echo "با موفقیت خارج شدید!"
    exit 0
fi

if [[ "$MENU" == "1" ]]; then
    VERSIONCHR="7.19.3"
    ask_interface
    ask_disk
fi

if [[ "$MENU" == "2" ]]; then
    ask_interface
    ask_disk
    read -p "Enter MikroTik version (example: 7.19.3): " VERSIONCHR
fi

confirm

ADDRESS="$(ip -4 addr show $IFACE | grep global | awk '{print $2}' | head -n 1)"
GATEWAY="$(ip route list | grep default | awk '{print $3}')"

umount /mnt >/dev/null 2>&1

apt update -y
apt install -y pwgen coreutils unzip wget

echo ""
echo "Downloading MikroTik CHR $VERSIONCHR ..."
wget -4 "https://download.mikrotik.com/routeros/$VERSIONCHR/chr-$VERSIONCHR.img.zip" -O chr.img.zip

echo ""
echo "Extracting image..."
gunzip -c chr.img.zip > chr.img

echo ""
echo "Mounting image..."
mount -o loop,offset=33571840 chr.img /mnt

PASSWORD=$(pwgen 12 1)

echo "Username: admin"
echo "Password: $PASSWORD"

cat << EOF > /mnt/rw/autorun.scr
/ip address add address=$ADDRESS interface=[/interface ethernet find where name=ether1]
/ip route add gateway=$GATEWAY
/ip service disable telnet
/user set 0 name=admin password=$PASSWORD
/ip dns set server=8.8.8.8,1.1.1.1
EOF

echo ""
echo "CHR image prepared successfully!"
echo "Disk: /dev/$DISK"
echo "Interface: $IFACE"
echo "Gateway: $GATEWAY"
echo "IP Address: $ADDRESS"
echo ""
echo "Ready to write image to disk."

# ❗❗ DANGEROUS — uncomment only in your server ❗❗
echo u > /proc/sysrq-trigger
dd if=chr.img bs=1024 of=/dev/$DISK status=progress
sync
echo s > /proc/sysrq-trigger
echo b > /proc/sysrq-trigger

echo ""
echo "Installation steps completed (safe mode)."
echo "Enable dd + reboot lines to finalize installation."
exit 0
