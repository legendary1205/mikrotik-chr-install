#!/bin/bash

##############################################
#   R A P I D O   S E R V E R   (CYAN MENU)  #
##############################################

clear
echo -e "\e[96m"
echo "██████╗  █████╗ ██████╗ ██╗██╗   ██╗██████╗  █████╗ "
echo "██╔══██╗██╔══██╗██╔══██╗██║██║   ██║██╔══██╗██╔══██╗"
echo "██████╔╝███████║██████╔╝██║██║   ██║██████╔╝███████║"
echo "██╔══██╗██╔══██║██╔══██╗██║╚██╗ ██╔╝██╔══██╗██╔══██║"
echo "██████╔╝██║  ██║██║  ██║██║ ╚████╔╝ ██████╔╝██║  ██║"
echo "╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═════╝ ╚═╝  ╚═╝"
echo -e "\e[0m"

echo ""
echo "1) Install MikroTik (Automatic)"
echo "2) Install MikroTik (Custom)"
echo "3) Exit"
echo ""

read -p "Select option [1-3]: " MENU

##############################################
# FUNCTIONS
##############################################

ask_interface() {
    echo ""
    echo "Available interfaces:"
    ip link | awk -F': ' '/^[0-9]+:/{print " - " $2}'
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

##############################################
# OPTION 3 → EXIT
##############################################

if [[ "$MENU" == "3" ]]; then
    echo "با موفقیت خارج شدید"
    exit 0
fi

##############################################
# OPTION 1 → AUTOMATIC
##############################################

if [[ "$MENU" == "1" ]]; then
    ask_interface
    ask_disk

    VERSIONCHR="7.19.3"

    ADDRESS="ip addr show $IFACE | grep global | cut -d' ' -f 6 | head -n 1"
    GATEWAY="ip route list | grep default | cut -d' ' -f 3"

    confirm

    # =========================================
    # START INSTALLATION
    # =========================================
    eval ADDRESS=$ADDRESS
    eval GATEWAY=$GATEWAY

    apt update
    apt install -y pwgen coreutils unzip
    wget -4 https://download.mikrotik.com/routeros/$VERSIONCHR/chr-$VERSIONCHR.img.zip -O chr.img.zip
    gunzip -c chr.img.zip > chr.img
    mount -o loop,offset=33571840 chr.img /mnt

    PASSWORD=$(pwgen 12 1)

    echo "Username: admin"
    echo "Password: $PASSWORD"

    echo "/ip address add address=$ADDRESS interface=[/interface ethernet find where name=ether1]" > /mnt/rw/autorun.scr
    echo "/ip route add gateway=$GATEWAY" >> /mnt/rw/autorun.scr
    echo "/ip service disable telnet" >> /mnt/rw/autorun.scr
    echo "/user set 0 name=admin password=$PASSWORD" >> /mnt/rw/autorun.scr
    echo "/ip dns set server=8.8.8.8,1.1.1.1" >> /mnt/rw/autorun.scr

    # *** DANGEROUS – Uncomment manually ***
    # echo u > /proc/sysrq-trigger
    # dd if=chr.img bs=1024 of=/dev/$DISK
    # echo s > /proc/sysrq-trigger
    # echo b > /proc/sysrq-trigger

    exit 0
fi

##############################################
# OPTION 2 → CUSTOM
##############################################

if [[ "$MENU" == "2" ]]; then
    ask_interface
    ask_disk
    read -p "Enter MikroTik version (example: 7.19.3): " VERSIONCHR

    ADDRESS="ip addr show $IFACE | grep global | cut -d' ' -f 6 | head -n 1"
    GATEWAY="ip route list | grep default | cut -d' ' -f 3"

    confirm

    # =========================================
    # START INSTALLATION
    # =========================================
    eval ADDRESS=$ADDRESS
    eval GATEWAY=$GATEWAY

    apt update
    apt install -y pwgen coreutils unzip
    wget -4 https://download.mikrotik.com/routeros/$VERSIONCHR/chr-$VERSIONCHR.img.zip -O chr.img.zip
    gunzip -c chr.img.zip > chr.img
    mount -o loop,offset=33571840 chr.img /mnt

    PASSWORD=$(pwgen 12 1)

    echo "Username: admin"
    echo "Password: $PASSWORD"

    echo "/ip address add address=$ADDRESS interface=[/interface ethernet find where name=ether1]" > /mnt/rw/autorun.scr
    echo "/ip route add gateway=$GATEWAY" >> /mnt/rw/autorun.scr
    echo "/ip service disable telnet" >> /mnt/rw/autorun.scr
    echo "/user set 0 name=admin password=$PASSWORD" >> /mnt/rw/autorun.scr
    echo "/ip dns set server=8.8.8.8,1.1.1.1" >> /mnt/rw/autorun.scr

    # *** DANGEROUS – Uncomment manually ***
    # echo u > /proc/sysrq-trigger
    # dd if=chr.img bs=1024 of=/dev/$DISK
    # echo s > /proc/sysrq-trigger
    # echo b > /proc/sysrq-trigger

    exit 0
fi
