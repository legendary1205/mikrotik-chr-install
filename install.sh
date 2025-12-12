#!/bin/bash

# رنگ‌ها
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'

# نمایش بنر
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║   ███╗   ███╗██╗██╗  ██╗██████╗  ██████╗ ████████╗██╗██╗  ██╗               ║
║   ████╗ ████║██║██║ ██╔╝██╔══██╗██╔═══██╗╚══██╔══╝██║██║ ██╔╝               ║
║   ██╔████╔██║██║█████╔╝ ██████╔╝██║   ██║   ██║   ██║█████╔╝                ║
║   ██║╚██╔╝██║██║██╔═██╗ ██╔══██╗██║   ██║   ██║   ██║██╔═██╗                ║
║   ██║ ╚═╝ ██║██║██║  ██╗██║  ██║╚██████╔╝   ██║   ██║██║  ██╗               ║
║   ╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═╝╚═╝  ╚═╝               ║
║                                                                               ║
║                    🚀 RAPIDO CHR INSTALLER 🚀                                ║
║                         Fast & Reliable                                       ║
╚═══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# نمایش منوی اصلی
show_menu() {
    echo ""
    echo -e "${WHITE}╔════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║          ${GREEN}📋 MAIN MENU${WHITE}                 ║${NC}"
    echo -e "${WHITE}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${CYAN}[${WHITE}1${CYAN}]${NC} ${GREEN}⚡ Automatic Installation${NC}"
    echo -e "      ${BLUE}→${NC} Quick setup with default settings"
    echo ""
    echo -e "  ${CYAN}[${WHITE}2${CYAN}]${NC} ${YELLOW}🔧 Custom Installation${NC}"
    echo -e "      ${BLUE}→${NC} Choose your own version"
    echo ""
    echo -e "  ${CYAN}[${WHITE}3${CYAN}]${NC} ${RED}🚪 Exit${NC}"
    echo -e "      ${BLUE}→${NC} Close the installer"
    echo ""
    echo -e "${WHITE}────────────────────────────────────────${NC}"
}

# تابع نصب (کد اصلی خودت)
install_mikrotik() {
    local interface=$1
    local disk=$2
    local version=$3
    
    ADDRESS=`ip addr show $interface | grep global | cut -d' ' -f 6 | head -n 1`
    GATEWAY=`ip route list | grep default | cut -d' ' -f 3`
    VERSIONCHR=$version
     
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
    echo u > /proc/sysrq-trigger
    dd if=chr.img bs=1024 of=/dev/$disk
    echo "sync disk"
    echo s > /proc/sysrq-trigger
    echo "Sleep 10 seconds"
    read -t 10 -u 1
    echo "Ok, reboot"
    echo b > /proc/sysrq-trigger
}

# نصب خودکار
automatic_install() {
    show_banner
    echo -e "${WHITE}╔════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║    ${GREEN}⚡ AUTOMATIC INSTALLATION${WHITE}        ║${NC}"
    echo -e "${WHITE}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    # انتخاب کارت شبکه
    echo -e "${CYAN}┌─ Network Interfaces${NC}"
    echo -e "${CYAN}│${NC}"
    ip link show | grep -E '^[0-9]+:' | cut -d':' -f2 | tr -d ' ' | grep -v lo | while read iface; do
        echo -e "${CYAN}│${NC}  ${GREEN}✓${NC} $iface"
    done
    echo -e "${CYAN}└─${NC}"
    echo ""
    echo -e -n "${YELLOW}➜${NC} Enter interface name ${BLUE}[e.g., eth0]${NC}: "
    read interface
    
    if [ -z "$interface" ]; then
        echo ""
        echo -e "${RED}✗ Error:${NC} Interface name cannot be empty!"
        echo ""
        echo -n "Press Enter to return to menu..."
        read
        return
    fi
    
    # انتخاب دیسک
    echo ""
    echo -e "${CYAN}┌─ Available Disks${NC}"
    echo -e "${CYAN}│${NC}"
    lsblk -d -n -o NAME,SIZE | grep -v loop | while read disk_info; do
        echo -e "${CYAN}│${NC}  ${GREEN}✓${NC} $disk_info"
    done
    echo -e "${CYAN}└─${NC}"
    echo ""
    echo -e -n "${YELLOW}➜${NC} Enter disk name ${BLUE}[e.g., vda]${NC}: "
    read disk
    
    if [ -z "$disk" ]; then
        echo ""
        echo -e "${RED}✗ Error:${NC} Disk name cannot be empty!"
        echo ""
        echo -n "Press Enter to return to menu..."
        read
        return
    fi
    
    # تایید نهایی
    echo ""
    echo -e "${MAGENTA}╔════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║         📋 INSTALLATION SUMMARY        ║${NC}"
    echo -e "${MAGENTA}╠════════════════════════════════════════╣${NC}"
    echo -e "${MAGENTA}║${NC} ${CYAN}Interface:${NC}  ${WHITE}$interface${NC}"
    echo -e "${MAGENTA}║${NC} ${CYAN}Disk:${NC}       ${WHITE}/dev/$disk${NC}"
    echo -e "${MAGENTA}║${NC} ${CYAN}Version:${NC}    ${WHITE}7.14.3 (stable)${NC}"
    echo -e "${MAGENTA}╠════════════════════════════════════════╣${NC}"
    echo -e "${MAGENTA}║${NC} ${RED}⚠️  ALL DATA ON /dev/$disk WILL BE LOST!${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e -n "${YELLOW}➜${NC} Continue? ${GREEN}[yes]${NC}/${RED}[no]${NC}: "
    read confirm
    
    if [ "$confirm" == "yes" ] || [ "$confirm" == "y" ]; then
        echo ""
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}🚀 Starting Installation...${NC}"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        install_mikrotik "$interface" "$disk" "7.14.3"
    else
        echo ""
        echo -e "${RED}✗ Installation cancelled.${NC}"
        echo ""
        echo -n "Press Enter to return to menu..."
        read
    fi
}

# نصب سفارشی
custom_install() {
    show_banner
    echo -e "${WHITE}╔════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║     ${YELLOW}🔧 CUSTOM INSTALLATION${WHITE}          ║${NC}"
    echo -e "${WHITE}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    # انتخاب کارت شبکه
    echo -e "${CYAN}┌─ Network Interfaces${NC}"
    echo -e "${CYAN}│${NC}"
    ip link show | grep -E '^[0-9]+:' | cut -d':' -f2 | tr -d ' ' | grep -v lo | while read iface; do
        echo -e "${CYAN}│${NC}  ${GREEN}✓${NC} $iface"
    done
    echo -e "${CYAN}└─${NC}"
    echo ""
    echo -e -n "${YELLOW}➜${NC} Enter interface name ${BLUE}[e.g., eth0]${NC}: "
    read interface
    
    if [ -z "$interface" ]; then
        echo ""
        echo -e "${RED}✗ Error:${NC} Interface name cannot be empty!"
        echo ""
        echo -n "Press Enter to return to menu..."
        read
        return
    fi
    
    # انتخاب دیسک
    echo ""
    echo -e "${CYAN}┌─ Available Disks${NC}"
    echo -e "${CYAN}│${NC}"
    lsblk -d -n -o NAME,SIZE | grep -v loop | while read disk_info; do
        echo -e "${CYAN}│${NC}  ${GREEN}✓${NC} $disk_info"
    done
    echo -e "${CYAN}└─${NC}"
    echo ""
    echo -e -n "${YELLOW}➜${NC} Enter disk name ${BLUE}[e.g., vda]${NC}: "
    read disk
    
    if [ -z "$disk" ]; then
        echo ""
        echo -e "${RED}✗ Error:${NC} Disk name cannot be empty!"
        echo ""
        echo -n "Press Enter to return to menu..."
        read
        return
    fi
    
    # انتخاب نسخه
    echo ""
    echo -e "${CYAN}┌─ Recommended Versions${NC}"
    echo -e "${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}✓${NC} 7.16.1 ${BLUE}(Latest Stable)${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}✓${NC} 7.15.3"
    echo -e "${CYAN}│${NC}  ${GREEN}✓${NC} 7.14.3"
    echo -e "${CYAN}└─${NC}"
    echo ""
    echo -e -n "${YELLOW}➜${NC} Enter version ${BLUE}[e.g., 7.16.1]${NC}: "
    read version
    
    if [ -z "$version" ]; then
        echo ""
        echo -e "${RED}✗ Error:${NC} Version cannot be empty!"
        echo ""
        echo -n "Press Enter to return to menu..."
        read
        return
    fi
    
    # تایید نهایی
    echo ""
    echo -e "${MAGENTA}╔════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║         📋 INSTALLATION SUMMARY        ║${NC}"
    echo -e "${MAGENTA}╠════════════════════════════════════════╣${NC}"
    echo -e "${MAGENTA}║${NC} ${CYAN}Interface:${NC}  ${WHITE}$interface${NC}"
    echo -e "${MAGENTA}║${NC} ${CYAN}Disk:${NC}       ${WHITE}/dev/$disk${NC}"
    echo -e "${MAGENTA}║${NC} ${CYAN}Version:${NC}    ${WHITE}$version${NC}"
    echo -e "${MAGENTA}╠════════════════════════════════════════╣${NC}"
    echo -e "${MAGENTA}║${NC} ${RED}⚠️  ALL DATA ON /dev/$disk WILL BE LOST!${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e -n "${YELLOW}➜${NC} Continue? ${GREEN}[yes]${NC}/${RED}[no]${NC}: "
    read confirm
    
    if [ "$confirm" == "yes" ] || [ "$confirm" == "y" ]; then
        echo ""
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}🚀 Starting Installation...${NC}"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        install_mikrotik "$interface" "$disk" "$version"
    else
        echo ""
        echo -e "${RED}✗ Installation cancelled.${NC}"
        echo ""
        echo -n "Press Enter to return to menu..."
        read
    fi
}

# حلقه اصلی
while true; do
    show_banner
    show_menu
    echo -e -n "${YELLOW}➜${NC} Enter your choice ${CYAN}[1-3]${NC}: "
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
            echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
            echo -e "${GREEN}║   Thank you for using Rapido CHR!     ║${NC}"
            echo -e "${GREEN}║          👋 Goodbye! 👋                ║${NC}"
            echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
            echo ""
            exit 0
            ;;
        *)
            echo ""
            echo -e "${RED}✗ Invalid option!${NC} Please enter ${CYAN}1${NC}, ${CYAN}2${NC}, or ${CYAN}3${NC}"
            echo ""
            echo -n "Press Enter to continue..."
            read
            ;;
    esac
done
