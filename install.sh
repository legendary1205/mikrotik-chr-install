#!/bin/bash

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to display Rapido Server banner
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
    ██████╗ ██████╗ ███╗   ██╗███████╗    ████████╗ █████╗  ██████╗██╗  ██╗███████╗██████╗ 
    ██╔══██╗██╔══██╗████╗  ██║██╔════╝    ╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
    ██████╔╝██████╔╝██╔██╗ ██║███████╗       ██║   ███████║██║     █████╔╝ █████╗  ██████╔╝
    ██╔══██╗██╔══██╗██║╚██╗██║╚════██║       ██║   ██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
    ██║  ██║██████╔╝██║ ╚████║███████║       ██║   ██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
    ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═══╝╚══════╝       ╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
EOF
    echo -e "${NC}"
    echo ""
}

# Function to show main menu
show_menu() {
    echo -e "${GREEN}Please select an option:${NC}"
    echo ""
    echo -e "${CYAN}1)${NC} ${GREEN}Install MikroTik Automatic${NC}"
    echo -e "${CYAN}2)${NC} ${GREEN}Install MikroTik Custom${NC}"
    echo -e "${CYAN}3)${NC} ${GREEN}Exit${NC}"
    echo ""
}

# Function to install MikroTik (base script logic)
install_mikrotik() {
    local INTERFACE=$1
    local DISK=$2
    local VERSIONCHR=$3
    
    echo ""
    echo -e "${YELLOW}Starting MikroTik installation...${NC}"
    sleep 1
    
    # Get network configuration using provided interface
    ADDRESS=$(ip addr show "$INTERFACE" | grep global | cut -d' ' -f 6 | head -n 1)
    GATEWAY=$(ip route list | grep default | cut -d' ' -f 3)
    
    echo -e "${CYAN}Detected IP: $ADDRESS${NC}"
    echo -e "${CYAN}Detected Gateway: $GATEWAY${NC}"
    
    # Update packages and install requirements
    echo -e "${CYAN}Installing required packages...${NC}"
    apt update
    apt install -y pwgen coreutils unzip
    
    # Download CHR image
    echo -e "${CYAN}Downloading MikroTik CHR $VERSIONCHR...${NC}"
    wget -4 "https://download.mikrotik.com/routeros/$VERSIONCHR/chr-$VERSIONCHR.img.zip" -O chr.img.zip
    
    # Extract image
    echo -e "${CYAN}Extracting image...${NC}"
    gunzip -c chr.img.zip > chr.img
    
    # Generate password
    PASSWORD=$(pwgen 12 1)
    
    echo -e "${GREEN}Generated credentials:${NC}"
    echo -e "${YELLOW}Username:${NC} admin"
    echo -e "${YELLOW}Password:${NC} $PASSWORD"
    echo ""
    
    # Mount image and create autorun script
    echo -e "${CYAN}Creating configuration...${NC}"
    mount -o loop,offset=33571840 chr.img /mnt
    
    echo "/ip address add address=$ADDRESS interface=[/interface ethernet find where name=ether1]" > /mnt/rw/autorun.scr
    echo "/ip route add gateway=$GATEWAY" >> /mnt/rw/autorun.scr
    echo "/ip service disable telnet" >> /mnt/rw/autorun.scr
    echo "/user set 0 name=admin password=$PASSWORD" >> /mnt/rw/autorun.scr
    echo "/ip dns set server=8.8.8.8,1.1.1.1" >> /mnt/rw/autorun.scr
    
    # Unmount filesystems
    echo -e "${CYAN}Syncing filesystems...${NC}"
    echo u > /proc/sysrq-trigger
    
    # Write image to disk
    echo -e "${CYAN}Writing image to /dev/$DISK...${NC}"
    echo -e "${RED}⚠️  ALL DATA ON /dev/$DISK WILL BE DESTROYED!${NC}"
    dd if=chr.img bs=1024 of=/dev/"$DISK"
    
    echo -e "${CYAN}Syncing disk...${NC}"
    echo s > /proc/sysrq-trigger
    
    echo -e "${GREEN}Installation completed successfully!${NC}"
    echo ""
    echo -e "${YELLOW}Server will reboot in 10 seconds...${NC}"
    echo -e "${RED}Press Ctrl+C to cancel${NC}"
    
    read -t 10 -u 1
    echo b > /proc/sysrq-trigger
}

# Automatic installation
automatic_install() {
    show_banner
    echo -e "${GREEN}=== Automatic Installation ===${NC}"
    echo ""
    
    # Get network interface
    echo -e "${CYAN}Available network interfaces:${NC}"
    ip link show | grep -E '^[0-9]+:' | cut -d':' -f2 | tr -d ' ' | grep -v lo
    echo ""
    echo -n -e "${YELLOW}Enter network interface [e.g., eth0, ens3]: ${NC}"
    read INTERFACE
    
    if [ -z "$INTERFACE" ]; then
        echo -e "${RED}Error: Interface cannot be empty!${NC}"
        echo -n "Press Enter to return to menu..."
        read
        return
    fi
    
    # Get disk
    echo ""
    echo -e "${CYAN}Available disks:${NC}"
    lsblk -d -n -o NAME,SIZE | grep -v loop
    echo ""
    echo -n -e "${YELLOW}Enter disk name [e.g., vda, sda]: ${NC}"
    read DISK
    
    if [ -z "$DISK" ]; then
        echo -e "${RED}Error: Disk cannot be empty!${NC}"
        echo -n "Press Enter to return to menu..."
        read
        return
    fi
    
    # Confirmation
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}Installation Summary:${NC}"
    echo -e "${CYAN}Interface:${NC} $INTERFACE"
    echo -e "${CYAN}Disk:${NC} /dev/$DISK"
    echo -e "${CYAN}Version:${NC} 7.19.3"
    echo -e "${RED}⚠️  ALL DATA ON /dev/$DISK WILL BE LOST!${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════${NC}"
    echo ""
    echo -n -e "${GREEN}Continue? [yes/no]: ${NC}"
    read CONFIRM
    
    if [[ "$CONFIRM" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        install_mikrotik "$INTERFACE" "$DISK" "7.19.3"
    else
        echo -e "${RED}Installation cancelled.${NC}"
        echo -n "Press Enter to return to menu..."
        read
    fi
}

# Custom installation
custom_install() {
    show_banner
    echo -e "${GREEN}=== Custom Installation ===${NC}"
    echo ""
    
    # Get network interface
    echo -e "${CYAN}Available network interfaces:${NC}"
    ip link show | grep -E '^[0-9]+:' | cut -d':' -f2 | tr -d ' ' | grep -v lo
    echo ""
    echo -n -e "${YELLOW}Enter network interface [e.g., eth0, ens3]: ${NC}"
    read INTERFACE
    
    if [ -z "$INTERFACE" ]; then
        echo -e "${RED}Error: Interface cannot be empty!${NC}"
        echo -n "Press Enter to return to menu..."
        read
        return
    fi
    
    # Get disk
    echo ""
    echo -e "${CYAN}Available disks:${NC}"
    lsblk -d -n -o NAME,SIZE | grep -v loop
    echo ""
    echo -n -e "${YELLOW}Enter disk name [e.g., vda, sda]: ${NC}"
    read DISK
    
    if [ -z "$DISK" ]; then
        echo -e "${RED}Error: Disk cannot be empty!${NC}"
        echo -n "Press Enter to return to menu..."
        read
        return
    fi
    
    # Get version
    echo ""
    echo -n -e "${YELLOW}Enter MikroTik version [e.g., 7.19.3]: ${NC}"
    read VERSIONCHR
    
    if [ -z "$VERSIONCHR" ]; then
        echo -e "${RED}Error: Version cannot be empty!${NC}"
        echo -n "Press Enter to return to menu..."
        read
        return
    fi
    
    # Confirmation
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}Installation Summary:${NC}"
    echo -e "${CYAN}Interface:${NC} $INTERFACE"
    echo -e "${CYAN}Disk:${NC} /dev/$DISK"
    echo -e "${CYAN}Version:${NC} $VERSIONCHR"
    echo -e "${RED}⚠️  ALL DATA ON /dev/$DISK WILL BE LOST!${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════${NC}"
    echo ""
    echo -n -e "${GREEN}Continue? [yes/no]: ${NC}"
    read CONFIRM
    
    if [[ "$CONFIRM" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        install_mikrotik "$INTERFACE" "$DISK" "$VERSIONCHR"
    else
        echo -e "${RED}Installation cancelled.${NC}"
        echo -n "Press Enter to return to menu..."
        read
    fi
}

# Main menu loop
while true; do
    show_banner
    show_menu
    
    echo -n -e "${YELLOW}Enter your choice [1-3]: ${NC}"
    read CHOICE
    
    case $CHOICE in
        1)
            automatic_install
            ;;
        2)
            custom_install
            ;;
        3)
            show_banner
            echo -e "${GREEN}═══════════════════════════════════════════${NC}"
            echo -e "${GREEN}        با موفقیت خارج شدید!${NC}"
            echo -e "${GREEN}        Thank you for using Rapido Server!${NC}"
            echo -e "${GREEN}═══════════════════════════════════════════${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option! Please enter 1, 2, or 3${NC}"
            echo ""
            echo -n -e "${YELLOW}Press Enter to continue...${NC}"
            read
            ;;
    esac
done
