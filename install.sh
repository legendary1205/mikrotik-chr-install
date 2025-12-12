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

# Function to generate random password
generate_password() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1
}

# Function to install MikroTik
install_mikrotik() {
    local interface=$1
    local disk=$2
    local version=$3
    
    echo ""
    echo -e "${YELLOW}Starting installation...${NC}"
    sleep 1
    
    # Update and install required packages
    echo -e "${CYAN}Installing required packages...${NC}"
    apt-get update -qq
    apt-get install -y wget unzip > /dev/null 2>&1
    sleep 1
    
    # Download MikroTik CHR
    VERSIONCHR="$version"
    echo -e "${CYAN}Downloading MikroTik CHR version ${VERSIONCHR}...${NC}"
    wget -q "https://download.mikrotik.com/routeros/${VERSIONCHR}/chr-${VERSIONCHR}.img.zip" -O chr.img.zip
    
    if [ ! -f chr.img.zip ]; then
        echo -e "${RED}Download failed! Please check the version number.${NC}"
        sleep 3
        return 1
    fi
    
    # Extract the image
    echo -e "${CYAN}Extracting image...${NC}"
    unzip -q chr.img.zip
    mv "chr-${VERSIONCHR}.img" chr.img
    rm chr.img.zip
    sleep 1
    
    # Get network configuration
    echo -e "${CYAN}Detecting network configuration...${NC}"
    ADDRESS=$(ip addr show "$interface" | grep global | awk '{print $2}' | head -n 1 | cut -d'/' -f1)
    GATEWAY=$(ip route list | grep default | awk '{print $3}' | head -n 1)
    
    echo "Interface IP: $ADDRESS"
    echo "Gateway: $GATEWAY"
    
    if [ -z "$ADDRESS" ] || [ -z "$GATEWAY" ]; then
        echo -e "${RED}Failed to detect network configuration!${NC}"
        echo "Please check interface name: $interface"
        sleep 3
        return 1
    fi
    
    # Generate random password
    PASSWORD=$(generate_password)
    
    # Create autorun configuration
    echo -e "${CYAN}Creating configuration...${NC}"
    cat > /tmp/chr-config.rsc << EOF
/interface ethernet set [ find default-name=ether1 ] name=ether1
/ip address add address=${ADDRESS}/24 interface=ether1
/ip route add gateway=${GATEWAY}
/ip dns set servers=8.8.8.8,1.1.1.1
/ip service disable telnet
/user set 0 password=${PASSWORD}
EOF
    sleep 1
    
    # Mount the image and copy config
    echo -e "${CYAN}Applying configuration...${NC}"
    mkdir -p /mnt/chr
    mount -o loop,offset=512 chr.img /mnt/chr 2>/dev/null || mount -o loop chr.img /mnt/chr
    mkdir -p /mnt/chr/rw 2>/dev/null
    cp /tmp/chr-config.rsc /mnt/chr/rw/autorun.rsc 2>/dev/null || cp /tmp/chr-config.rsc /mnt/chr/autorun.rsc
    umount /mnt/chr 2>/dev/null || true
    rmdir /mnt/chr 2>/dev/null || true
    sleep 1
    
    # Write image to disk
    echo -e "${CYAN}Writing image to disk /dev/${disk}...${NC}"
    echo 1 > /proc/sys/kernel/sysrq
    echo u > /proc/sysrq-trigger
    sleep 2
    dd if=chr.img bs=1M of=/dev/"$disk" status=progress
    sync
    rm chr.img
    
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
    
    echo -e "${YELLOW}Press Ctrl+C to cancel reboot or wait 10 seconds...${NC}"
    sleep 10
    reboot
}

# Function for automatic installation
automatic_install() {
    while true; do
        show_banner
        echo -e "${GREEN}=== Automatic Installation ===${NC}"
        echo ""
        
        # Show available interfaces
        echo -e "${CYAN}Available network interfaces:${NC}"
        ip link show | grep -E '^[0-9]+:' | cut -d':' -f2 | sed 's/^[ \t]*//' | grep -v lo | sed 's/://g'
        echo ""
        echo -n -e "${YELLOW}Enter network interface name [e.g., eth0, ens3]: ${NC}"
        read -r interface
        
        if [ -z "$interface" ]; then
            echo -e "${RED}Error: Interface name cannot be empty!${NC}"
            sleep 2
            continue
        fi
        
        # Show available disks
        echo ""
        echo -e "${CYAN}Available disks:${NC}"
        lsblk -dno NAME,SIZE,TYPE | grep -E 'disk' | grep -v loop
        echo ""
        echo -n -e "${YELLOW}Enter disk name [e.g., vda, sda]: ${NC}"
        read -r disk
        
        if [ -z "$disk" ]; then
            echo -e "${RED}Error: Disk name cannot be empty!${NC}"
            sleep 2
            continue
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
        echo -n -e "${GREEN}Continue? [yes/no]: ${NC}"
        read -r confirm
        
        if [[ "$confirm" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            install_mikrotik "$interface" "$disk" "7.19.3"
            break
        else
            echo -e "${RED}Installation cancelled.${NC}"
            echo ""
            echo -n -e "${YELLOW}Press Enter to continue...${NC}"
            read -r
        fi
    done
}

# Function for custom installation
custom_install() {
    while true; do
        show_banner
        echo -e "${GREEN}=== Custom Installation ===${NC}"
        echo ""
        
        # Show available interfaces
        echo -e "${CYAN}Available network interfaces:${NC}"
        ip link show | grep -E '^[0-9]+:' | cut -d':' -f2 | sed 's/^[ \t]*//' | grep -v lo | sed 's/://g'
        echo ""
        echo -n -e "${YELLOW}Enter network interface name [e.g., eth0, ens3]: ${NC}"
        read -r interface
        
        if [ -z "$interface" ]; then
            echo -e "${RED}Error: Interface name cannot be empty!${NC}"
            sleep 2
            continue
        fi
        
        # Show available disks
        echo ""
        echo -e "${CYAN}Available disks:${NC}"
        lsblk -dno NAME,SIZE,TYPE | grep -E 'disk' | grep -v loop
        echo ""
        echo -n -e "${YELLOW}Enter disk name [e.g., vda, sda]: ${NC}"
        read -r disk
        
        if [ -z "$disk" ]; then
            echo -e "${RED}Error: Disk name cannot be empty!${NC}"
            sleep 2
            continue
        fi
        
        # Get MikroTik version
        echo ""
        echo -n -e "${YELLOW}Enter MikroTik version [e.g., 7.19.3, 7.18]: ${NC}"
        read -r version
        
        if [ -z "$version" ]; then
            echo -e "${RED}Error: Version cannot be empty!${NC}"
            sleep 2
            continue
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
        echo -n -e "${GREEN}Continue? [yes/no]: ${NC}"
        read -r confirm
        
        if [[ "$confirm" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            install_mikrotik "$interface" "$disk" "$version"
            break
        else
            echo -e "${RED}Installation cancelled.${NC}"
            echo ""
            echo -n -e "${YELLOW}Press Enter to continue...${NC}"
            read -r
        fi
    done
}

# Main loop
while true; do
    show_banner
    show_menu
    
    echo -n -e "${YELLOW}Enter your choice [1-3]: ${NC}"
    read -r choice
    
    case $choice in
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
            echo ""
            sleep 2
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please enter 1, 2, or 3${NC}"
            echo ""
            echo -n -e "${YELLOW}Press Enter to continue...${NC}"
            read -r
            ;;
    esac
done
