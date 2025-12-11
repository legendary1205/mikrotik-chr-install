#!/bin/bash

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Function to display banner
show_banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "  ____                  _     _         ____                                "
    echo " |  _ \\ __ _ _ __   (_) __| | ___   / ___|  ___ _ ____   _____ _ __    "
    echo " | |_) / _\` | '_ \\  | |/ _\` |/ _ \\  \\___ \\ / _ \\ '__\\ \\ / / _ \\ '__|"
    echo " |  _ < (_| | |_) | | | (_| | (_) |  ___) |  __/ |   \\ V /  __/ |      "
    echo " |_| \\_\\__,_| .__/  |_|\\__,_|\\___/  |____/ \\___|_|    \\_/ \\___|_|   "
    echo "            |_|                                                           "
    echo -e "${NC}"
}

# Function to display menu
show_menu() {
    echo -e "${YELLOW}${BOLD}Please select an option:${NC}\n"
    echo -e "${GREEN}1)${NC} Install MikroTik Automatic"
    echo -e "${GREEN}2)${NC} Install MikroTik Custom"
    echo -e "${GREEN}3)${NC} Exit"
    echo ""
    echo -ne "${YELLOW}Enter your choice [1-3]: ${NC}"
}

# Function to install MikroTik
install_mikrotik() {
    local NETWORK_INTERFACE=$1
    local DISK=$2
    local VERSION=$3
    
    # Get IP address and gateway
    ADDRESS=$(ip addr show $NETWORK_INTERFACE | grep global | cut -d' ' -f 6 | head -n 1)
    GATEWAY=$(ip route list | grep default | cut -d' ' -f 3)
    
    echo -e "\n${CYAN}Starting MikroTik installation...${NC}"
    
    # Install dependencies
    echo -e "${YELLOW}Installing dependencies...${NC}"
    apt update
    apt install -y pwgen coreutils unzip wget
    
    # Download MikroTik CHR
    echo -e "${YELLOW}Downloading MikroTik CHR version $VERSION...${NC}"
    wget -4 https://download.mikrotik.com/routeros/$VERSION/chr-$VERSION.img.zip -O chr.img.zip
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to download MikroTik CHR${NC}"
        exit 1
    fi
    
    # Extract image
    echo -e "${YELLOW}Extracting image...${NC}"
    gunzip -c chr.img.zip > chr.img
    
    # Mount and configure
    echo -e "${YELLOW}Configuring MikroTik...${NC}"
    mount -o loop,offset=33571840 chr.img /mnt
    
    # Generate password
    PASSWORD=$(pwgen 12 1)
    
    # Create autorun script
    echo "/ip address add address=$ADDRESS interface=[/interface ethernet find where name=ether1]" > /mnt/rw/autorun.scr
    echo "/ip route add gateway=$GATEWAY" >> /mnt/rw/autorun.scr
    echo "/ip service disable telnet" >> /mnt/rw/autorun.scr
    echo "/user set 0 name=admin password=$PASSWORD" >> /mnt/rw/autorun.scr
    echo "/ip dns set server=8.8.8.8,1.1.1.1" >> /mnt/rw/autorun.scr
    
    # Write to disk
    echo -e "${YELLOW}Writing to disk /dev/$DISK...${NC}"
    echo u > /proc/sysrq-trigger
    dd if=chr.img bs=1024 of=/dev/$DISK
    
    echo -e "\n${GREEN}${BOLD}Installation completed successfully!${NC}"
    echo -e "${CYAN}Login credentials:${NC}"
    echo -e "Username: ${BOLD}admin${NC}"
    echo -e "Password: ${BOLD}$PASSWORD${NC}"
    
    echo -e "\n${YELLOW}Syncing disk...${NC}"
    echo s > /proc/sysrq-trigger
    
    echo -e "${YELLOW}System will reboot in 10 seconds...${NC}"
    read -t 10 -u 1
    
    echo -e "${GREEN}Rebooting...${NC}"
    echo b > /proc/sysrq-trigger
}

# Function for automatic installation
automatic_install() {
    echo -e "\n${CYAN}${BOLD}=== Automatic Installation ===${NC}\n"
    
    # Get network interface
    echo -e "${YELLOW}Available network interfaces:${NC}"
    ip -o link show | awk -F': ' '{print $2}' | grep -v lo
    echo ""
    echo -ne "${YELLOW}Enter network interface name (e.g., eth0, ens3): ${NC}"
    read NETWORK_INTERFACE
    
    if [ -z "$NETWORK_INTERFACE" ]; then
        echo -e "${RED}Error: Network interface cannot be empty${NC}"
        return
    fi
    
    # Get disk name
    echo -ne "${YELLOW}Enter disk name (vda or sda): ${NC}"
    read DISK
    
    if [ -z "$DISK" ]; then
        echo -e "${RED}Error: Disk name cannot be empty${NC}"
        return
    fi
    
    # Default version
    VERSION="7.19.3"
    
    # Confirmation
    echo -e "\n${CYAN}${BOLD}Installation Summary:${NC}"
    echo -e "Network Interface: ${GREEN}$NETWORK_INTERFACE${NC}"
    echo -e "Disk: ${GREEN}/dev/$DISK${NC}"
    echo -e "MikroTik Version: ${GREEN}$VERSION${NC}"
    echo ""
    echo -ne "${YELLOW}Are you sure you want to continue? (yes/no): ${NC}"
    read CONFIRM
    
    if [[ "$CONFIRM" == "yes" || "$CONFIRM" == "YES" || "$CONFIRM" == "y" ]]; then
        install_mikrotik "$NETWORK_INTERFACE" "$DISK" "$VERSION"
    else
        echo -e "${RED}Installation cancelled${NC}"
    fi
}

# Function for custom installation
custom_install() {
    echo -e "\n${CYAN}${BOLD}=== Custom Installation ===${NC}\n"
    
    # Get network interface
    echo -e "${YELLOW}Available network interfaces:${NC}"
    ip -o link show | awk -F': ' '{print $2}' | grep -v lo
    echo ""
    echo -ne "${YELLOW}Enter network interface name (e.g., eth0, ens3): ${NC}"
    read NETWORK_INTERFACE
    
    if [ -z "$NETWORK_INTERFACE" ]; then
        echo -e "${RED}Error: Network interface cannot be empty${NC}"
        return
    fi
    
    # Get disk name
    echo -ne "${YELLOW}Enter disk name (vda or sda): ${NC}"
    read DISK
    
    if [ -z "$DISK" ]; then
        echo -e "${RED}Error: Disk name cannot be empty${NC}"
        return
    fi
    
    # Get MikroTik version
    echo -ne "${YELLOW}Enter MikroTik version (e.g., 7.19.3): ${NC}"
    read VERSION
    
    if [ -z "$VERSION" ]; then
        echo -e "${RED}Error: Version cannot be empty${NC}"
        return
    fi
    
    # Confirmation
    echo -e "\n${CYAN}${BOLD}Installation Summary:${NC}"
    echo -e "Network Interface: ${GREEN}$NETWORK_INTERFACE${NC}"
    echo -e "Disk: ${GREEN}/dev/$DISK${NC}"
    echo -e "MikroTik Version: ${GREEN}$VERSION${NC}"
    echo ""
    echo -ne "${YELLOW}Are you sure you want to continue? (yes/no): ${NC}"
    read CONFIRM
    
    if [[ "$CONFIRM" == "yes" || "$CONFIRM" == "YES" || "$CONFIRM" == "y" ]]; then
        install_mikrotik "$NETWORK_INTERFACE" "$DISK" "$VERSION"
    else
        echo -e "${RED}Installation cancelled${NC}"
    fi
}

# Main script
show_banner

while true; do
    show_menu
    read choice
    
    case $choice in
        1)
            automatic_install
            break
            ;;
        2)
            custom_install
            break
            ;;
        3)
            echo -e "\n${GREEN}${BOLD}Successfully exited. Goodbye!${NC}\n"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please select 1, 2, or 3${NC}\n"
            sleep 2
            show_banner
            ;;
    esac
done
