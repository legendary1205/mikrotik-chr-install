#!/bin/bash

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to display banner
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
██████╗  █████╗ ██████╗ ██╗██████╗  ██████╗     ███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗ 
██╔══██╗██╔══██╗██╔══██╗██║██╔══██╗██╔═══██╗    ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗
██████╔╝███████║██████╔╝██║██║  ██║██║   ██║    ███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝
██╔══██╗██╔══██║██╔═══╝ ██║██║  ██║██║   ██║    ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗
██║  ██║██║  ██║██║     ██║██████╔╝╚██████╔╝    ███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝  ╚═════╝     ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝
EOF
    echo -e "${NC}"
    echo ""
}

# Function to show main menu
show_menu() {
    echo -e "${GREEN}Please select an option:${NC}"
    echo ""
    echo -e "${CYAN}1)${NC} Install MikroTik Automatic"
    echo -e "${CYAN}2)${NC} Install MikroTik Custom"
    echo -e "${CYAN}3)${NC} Exit"
    echo ""
}

# Function to generate random password
generate_password() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1
}

# Function to install MikroTik
install_mikrotik() {
    local interface=$1
    local disk=$2
    local version=$3
    
    echo -e "${YELLOW}Starting installation...${NC}"
    
    # Update and install required packages
    echo -e "${CYAN}Installing required packages...${NC}"
    apt-get update -qq
    apt-get install -y wget unzip > /dev/null 2>&1
    
    # Download MikroTik CHR
    VERSIONCHR="$version"
    echo -e "${CYAN}Downloading MikroTik CHR version ${VERSIONCHR}...${NC}"
    wget -q https://download.mikrotik.com/routeros/${VERSIONCHR}/chr-${VERSIONCHR}.img.zip -O chr.img.zip
    
    if [ ! -f chr.img.zip ]; then
        echo -e "${RED}Download failed! Please check the version number.${NC}"
        exit 1
    fi
    
    # Extract the image
    echo -e "${CYAN}Extracting image...${NC}"
    gunzip -c chr.img.zip > chr.img
    
    # Get network configuration
    ADDRESS=$(ip addr show $interface | grep global | cut -d' ' -f 6 | head -n 1)
    GATEWAY=$(ip route list | grep default | cut -d' ' -f 3)
    
    if [ -z "$ADDRESS" ] || [ -z "$GATEWAY" ]; then
        echo -e "${RED}Failed to detect network configuration!${NC}"
        exit 1
    fi
    
    # Generate random password
    PASSWORD=$(generate_password)
    
    # Create autorun configuration
    echo -e "${CYAN}Creating configuration...${NC}"
    cat > /tmp/chr-config.rsc << EOF
/interface ethernet set [ find default-name=ether1 ] name=ether1
/ip address add address=${ADDRESS} interface=ether1
/ip route add gateway=${GATEWAY}
/ip dns set servers=8.8.8.8,1.1.1.1
/ip service disable telnet
/user set 0 password=${PASSWORD}
EOF
    
    # Mount the image and copy config
    echo -e "${CYAN}Applying configuration...${NC}"
    mkdir -p /mnt/chr
    mount -o loop,offset=512 chr.img /mnt/chr
    cp /tmp/chr-config.rsc /mnt/chr/rw/autorun.scr
    umount /mnt/chr
    
    # Write image to disk
    echo -e "${CYAN}Writing image to disk /dev/${disk}...${NC}"
    echo u > /proc/sysrq-trigger
    dd if=chr.img bs=1024 of=/dev/${disk}
    
    # Display completion message
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    echo -e "${GREEN}        Installation Complete!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}Username:${NC} admin"
    echo -e "${YELLOW}Password:${NC} ${PASSWORD}"
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    echo -e "${RED}⚠️  SAVE THIS PASSWORD NOW!${NC}"
    echo -e "${YELLOW}Server will reboot in 10 seconds...${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    echo ""
    
    sleep 10
    reboot
}

# Function for automatic installation
automatic_install() {
    show_banner
    echo -e "${GREEN}=== Automatic Installation ===${NC}"
    echo ""
    
    # Get interface name
    echo -e "${CYAN}Available network interfaces:${NC}"
    ip link show | grep -E '^[0-9]+:' | cut -d':' -f2 | tr -d ' ' | grep -v lo
    echo ""
    echo -e -n "${YELLOW}Enter network interface name [e.g., eth0, ens3]: ${NC}"
    read interface
    
    if [ -z "$interface" ]; then
        echo -e "${RED}Error: Interface name cannot be empty!${NC}"
        sleep 2
        return
    fi
    
    # Get disk name
    echo ""
    echo -e "${CYAN}Available disks:${NC}"
    lsblk -d -n -o NAME,SIZE | grep -v loop
    echo ""
    echo -e -n "${YELLOW}Enter disk name [e.g., vda, sda]: ${NC}"
    read disk
    
    if [ -z "$disk" ]; then
        echo -e "${RED}Error: Disk name cannot be empty!${NC}"
        sleep 2
        return
    fi
    
    # Confirmation
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}You are about to install MikroTik with:${NC}"
    echo -e "${CYAN}Interface:${NC} $interface"
    echo -e "${CYAN}Disk:${NC} /dev/$disk"
    echo -e "${CYAN}Version:${NC} 7.19.3 (default)"
    echo -e "${RED}⚠️  ALL DATA ON /dev/$disk WILL BE LOST!${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════${NC}"
    echo ""
    echo -e -n "${YELLOW}Continue? [yes/no]: ${NC}"
    read confirm
    
    if [ "$confirm" == "yes" ] || [ "$confirm" == "y" ]; then
        install_mikrotik "$interface" "$disk" "7.19.3"
    else
        echo -e "${RED}Installation cancelled.${NC}"
        sleep 2
    fi
}

# Function for custom installation
custom_install() {
    show_banner
    echo -e "${GREEN}=== Custom Installation ===${NC}"
    echo ""
    
    # Get interface name
    echo -e "${CYAN}Available network interfaces:${NC}"
    ip link show | grep -E '^[0-9]+:' | cut -d':' -f2 | tr -d ' ' | grep -v lo
    echo ""
    echo -e -n "${YELLOW}Enter network interface name [e.g., eth0, ens3]: ${NC}"
    read interface
    
    if [ -z "$interface" ]; then
        echo -e "${RED}Error: Interface name cannot be empty!${NC}"
        sleep 2
        return
    fi
    
    # Get disk name
    echo ""
    echo -e "${CYAN}Available disks:${NC}"
    lsblk -d -n -o NAME,SIZE | grep -v loop
    echo ""
    echo -e -n "${YELLOW}Enter disk name [e.g., vda, sda]: ${NC}"
    read disk
    
    if [ -z "$disk" ]; then
        echo -e "${RED}Error: Disk name cannot be empty!${NC}"
        sleep 2
        return
    fi
    
    # Get MikroTik version
    echo ""
    echo -e -n "${YELLOW}Enter MikroTik version [e.g., 7.19.3, 7.18]: ${NC}"
    read version
    
    if [ -z "$version" ]; then
        echo -e "${RED}Error: Version cannot be empty!${NC}"
        sleep 2
        return
    fi
    
    # Confirmation
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}You are about to install MikroTik with:${NC}"
    echo -e "${CYAN}Interface:${NC} $interface"
    echo -e "${CYAN}Disk:${NC} /dev/$disk"
    echo -e "${CYAN}Version:${NC} $version"
    echo -e "${RED}⚠️  ALL DATA ON /dev/$disk WILL BE LOST!${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════${NC}"
    echo ""
    echo -e -n "${YELLOW}Continue? [yes/no]: ${NC}"
    read confirm
    
    if [ "$confirm" == "yes" ] || [ "$confirm" == "y" ]; then
        install_mikrotik "$interface" "$disk" "$version"
    else
        echo -e "${RED}Installation cancelled.${NC}"
        sleep 2
    fi
}

# Main loop
while true; do
    show_banner
    show_menu
    
    echo -e -n "${YELLOW}Enter your choice [1-3]: ${NC}"
    read choice
    
    case $choice in
        1)
            automatic_install
            ;;
        2)
            custom_install
            ;;
        3)
            show_banner
            echo -e "${GREEN}Thank you for using Rapido MikroTik Installer!${NC}"
            echo -e "${CYAN}Exiting...${NC}"
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please enter 1, 2, or 3${NC}"
            sleep 2
            ;;
    esac
done
