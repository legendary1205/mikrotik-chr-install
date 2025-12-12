#!/bin/bash

# ------------------- COLORS --------------------
CYAN="\e[96m"
NC="\e[0m"

# ------------------- MENU ----------------------
clear
echo -e "${CYAN}"
echo -e "██████╗  █████╗ ██████╗ ██╗██╗  ██████╗  ██████╗     ███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗ "
echo -e "██╔══██╗██╔══██╗██╔══██╗██║██║  ██╔══██╗██╔════╝     ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗"
echo -e "██████╔╝███████║██████╔╝██║██║  ██████╔╝██║  ███╗    ███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝"
echo -e "██╔══██╗██╔══██║██╔══██╗██║██║  ██╔══██╗██║   ██║    ╚════██║██╔══╝  ██╔══██╗██║   ██║██╔══╝  ██╔══██╗"
echo -e "██████╔╝██║  ██║██║  ██║██║██║  ██║  ██║╚██████╔╝    ███████║███████╗██║  ██║╚██████╔╝███████╗██║  ██║"
echo -e "╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝  ╚═╝ ╚═════╝     ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝"
echo -e "${NC}"

echo ""
echo "1) Install Mikrotik Automatic"
echo "2) Install Mikrotik Custom"
echo "3) Exit"
echo ""
read -p "Select an option (1/2/3): " menu

# ------------------- FUNCTIONS ----------------------

install_mikrotik() {
    local VERSION=$1

    echo ""
    read -p "Enter network interface name (ex: eth0): " NETIF
    read -p "Enter disk name (ex: vda or sda): " DISK

    ADDRESS="ip addr show $NETIF | grep global | cut -d' ' -f 6 | head -n 1"
    GATEWAY="ip route list | grep default | cut -d' ' -f 3"

    echo ""
    echo "-----------------------------------------"
    echo "Network Interface: $NETIF"
    echo "Disk: $DISK"
    echo "Version: $VERSION"
    echo "-----------------------------------------"
    read -p "Are you sure to install Mikrotik? (yes/no): " CONFIRM

    if [[ "$CONFIRM" != "yes" ]]; then
        echo "Installation canceled."
        exit 0
    fi

    # ------------------- INSTALLATION ----------------------

    apt update
    apt install -y pwgen coreutils unzip

    wget -4 https://download.mikrotik.com/routeros/$VERSION/chr-$VERSION.img.zip -O chr.img.zip
    gunzip -c chr.img.zip > chr.img

    mount -o loop,offset=33571840 chr.img /mnt

    PASSWORD=$(pwgen 12 1)
    echo "Username: admin"
    echo "Password: $PASSWORD"

    echo "/ip address add address=\$($ADDRESS) interface=[/interface ethernet find where name=ether1]" > /mnt/rw/autorun.scr
    echo "/ip route add gateway=\$($GATEWAY)" >> /mnt/rw/autorun.scr
    echo "/ip service disable telnet" >> /mnt/rw/autorun.scr
    echo "/user set 0 name=admin password=$PASSWORD" >> /mnt/rw/autorun.scr
    echo "/ip dns set server=8.8.8.8,1.1.1.1" >> /mnt/rw/autorun.scr

    echo u > /proc/sysrq-trigger
    dd if=chr.img bs=1024 of=/dev/$DISK

    echo "sync disk"
    echo s > /proc/sysrq-trigger

    echo "Rebooting in 10 seconds..."
    read -t 10 -u 1
    echo b > /proc/sysrq-trigger
}

# ------------------- MENU HANDLER ----------------------

case $menu in
1)
    install_mikrotik "7.19.3"
    ;;
2)
    read -p "Enter MikroTik version (ex: 7.19.3): " CUSTOM_VERSION
    install_mikrotik "$CUSTOM_VERSION"
    ;;
3)
    echo "با موفقیت خارج شدید."
    exit 0
    ;;
*)
    echo "Invalid option!"
    exit 1
    ;;
esac
