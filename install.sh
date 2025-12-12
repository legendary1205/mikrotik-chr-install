#!/bin/bash

# رنگ‌ها
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'

# نمایش بنر
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║   ███╗   ███╗██╗██╗  ██╗██████╗  ██████╗ ████████╗██╗██╗  ██╗                 ║
║   ████╗ ████║██║██║ ██╔╝██╔══██╗██╔═══██╗╚══██╔══╝██║██║ ██╔╝                 ║
║   ██╔████╔██║██║█████╔╝ ██████╔╝██║   ██║   ██║   ██║█████╔╝                  ║
║   ██║╚██╔╝██║██║██╔═██╗ ██╔══██╗██║   ██║   ██║   ██║██╔═██╗                  ║
║   ██║ ╚═╝ ██║██║██║  ██╗██║  ██║╚██████╔╝   ██║   ██║██║  ██╗                 ║
║   ╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═╝╚═╝  ╚═╝                 ║
║                                                                               ║
║                    🚀 RAPIDOSERVER CHR INSTALLER 🚀                           ║
║                            Fast & Reliable                                    ║
║                website: https://rapidoserver.com/                             ║ 
║               telegram: https://t.me/Rapidoserver                             ║ 
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# نمایش منوی اصلی
show_menu() {
    echo ""
    echo -e "${WHITE}╔════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║    ${GREEN}📋 MAIN MENU${WHITE}        ║${NC}"
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

# Progress bar
show_progress() {
    local current=$1
    local total=$2
    local text=$3
    local percent=$((current * 100 / total))
    local filled=$((percent / 2))
    local empty=$((50 - filled))
    
    echo -e -n "\r${CYAN}│${NC} "
    printf "%-40s" "$text"
    echo -n " ["
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    echo -n "] ${WHITE}${percent}%${NC} ${CYAN}│${NC}"
}

# نمایش مرحله
show_step() {
    local step=$1
    local total=$2
    local title=$3
    local icon=$4
    
    echo ""
    echo -e "${MAGENTA}╔════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC} ${icon} ${WHITE}Step ${step}/${total}: ${title}${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"
}

# تابع نصب با نمایش مراحل
install_mikrotik() {
    local interface=$1
    local disk=$2
    local version=$3
    local total_steps=9
    
    clear
    show_banner
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     🚀 INSTALLATION IN PROGRESS       ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    
    # مرحله 1: دریافت اطلاعات شبکه
    show_step 1 $total_steps "Network Configuration" "🌐"
    echo -e "${CYAN}┌─ Detecting network settings...${NC}"
    ADDRESS=`ip addr show $interface | grep global | cut -d' ' -f 6 | head -n 1`
    GATEWAY=`ip route list | grep default | cut -d' ' -f 3`
    echo -e "${CYAN}│${NC}  ${GREEN}✓${NC} IP Address: ${WHITE}$ADDRESS${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}✓${NC} Gateway: ${WHITE}$GATEWAY${NC}"
    echo -e "${CYAN}└─${NC}"
    sleep 1
    
    # مرحله 2: نصب ابزارها
    show_step 2 $total_steps "Installing Dependencies" "📦"
    echo -e "${CYAN}┌─ Installing required packages...${NC}"
    apt update > /dev/null 2>&1
    show_progress 1 3 "Updating package list" && sleep 0.5
    apt install -y pwgen > /dev/null 2>&1
    show_progress 2 3 "Installing pwgen" && sleep 0.5
    apt install -y coreutils unzip > /dev/null 2>&1
    show_progress 3 3 "Installing utilities"
    echo ""
    echo -e "${CYAN}│${NC}  ${GREEN}✓${NC} All dependencies installed"
    echo -e "${CYAN}└─${NC}"
    sleep 1
    
    # مرحله 3: دانلود CHR
    show_step 3 $total_steps "Downloading MikroTik CHR" "⬇️"
    echo -e "${CYAN}┌─ Downloading version ${WHITE}$version${NC}..."
    echo -e "${CYAN}│${NC}"
    wget -q --show-progress https://download.mikrotik.com/routeros/$version/chr-$version.img.zip -O chr.img.zip 2>&1 | grep --line-buffered "%" | sed -u -e "s,\.,,g" | awk '{printf("\r'${CYAN}'│'${NC}'  '${GREEN}'⬇'${NC}' Downloading... '${WHITE}'%s'${NC}' '${CYAN}'│'${NC}'"), $2+0}'
    echo ""
    echo -e "${CYAN}│${NC}  ${GREEN}✓${NC} Download completed"
    echo -e "${CYAN}└─${NC}"
    sleep 1
    
    # مرحله 4: استخراج فایل
    show_step 4 $total_steps "Extracting Image" "📂"
    echo -e "${CYAN}┌─ Extracting CHR image...${NC}"
    gunzip -c chr.img.zip > chr.img 2>/dev/null &
    pid=$!
    local i=0
    while kill -0 $pid 2>/dev/null; do
        show_progress $((i % 100 + 1)) 100 "Extracting image"
        sleep 0.1
        ((i++))
    done
    show_progress 100 100 "Extraction complete"
    echo ""
    echo -e "${CYAN}│${NC}  ${GREEN}✓${NC} Image extracted successfully"
    echo -e "${CYAN}└─${NC}"
    sleep 1
    
    # مرحله 5: نصب فایل سیستم
    show_step 5 $total_steps "Mounting Filesystem" "💾"
    echo -e "${CYAN}┌─ Mounting CHR image...${NC}"
    mount -o loop,offset=33571840 chr.img /mnt 2>/dev/null
    show_progress 100 100 "Mount complete"
    echo ""
    echo -e "${CYAN}│${NC}  ${GREEN}✓${NC} Filesystem mounted at /mnt"
    echo -e "${CYAN}└─${NC}"
    sleep 1
    
    # مرحله 6: تولید رمز عبور
    show_step 6 $total_steps "Generating Credentials" "🔐"
    echo -e "${CYAN}┌─ Creating secure password...${NC}"
    PASSWORD=$(pwgen 12 1)
    show_progress 100 100 "Password generated"
    echo ""
    echo -e "${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${YELLOW}⚠️  Save these credentials:${NC}"
    echo -e "${CYAN}│${NC}  ─────────────────────────────"
    echo -e "${CYAN}│${NC}  ${GREEN}Username:${NC} ${WHITE}admin${NC}"
    echo -e "${CYAN}│${NC}  ${GREEN}Password:${NC} ${WHITE}$PASSWORD${NC}"
    echo -e "${CYAN}│${NC}  ─────────────────────────────"
    echo -e "${CYAN}└─${NC}"
    sleep 2
    
    # مرحله 7: پیکربندی خودکار
    show_step 7 $total_steps "Creating AutoRun Script" "⚙️"
    echo -e "${CYAN}┌─ Writing configuration...${NC}"
    echo "/ip address add address=$ADDRESS interface=[/interface ethernet find where name=ether1]" > /mnt/rw/autorun.scr
    show_progress 20 100 "Network settings"
    sleep 0.3
    echo "/ip route add gateway=$GATEWAY" >> /mnt/rw/autorun.scr
    show_progress 40 100 "Gateway configuration"
    sleep 0.3
    echo "/ip service disable telnet" >> /mnt/rw/autorun.scr
    show_progress 60 100 "Security settings"
    sleep 0.3
    echo "/user set 0 name=admin password=$PASSWORD" >> /mnt/rw/autorun.scr
    show_progress 80 100 "User credentials"
    sleep 0.3
    echo "/ip dns set server=8.8.8.8,1.1.1.1" >> /mnt/rw/autorun.scr
    show_progress 100 100 "DNS configuration"
    echo ""
    echo -e "${CYAN}│${NC}  ${GREEN}✓${NC} AutoRun script created"
    echo -e "${CYAN}└─${NC}"
    sleep 1
    
    # مرحله 8: نوشتن بر روی دیسک
    show_step 8 $total_steps "Writing to Disk" "💿"
    echo -e "${CYAN}┌─ Preparing disk...${NC}"
    echo u > /proc/sysrq-trigger 2>/dev/null
    show_progress 25 100 "Unmounting filesystems"
    sleep 0.5
    echo -e "${CYAN}│${NC}"
    echo -e "${CYAN}│${NC}  ${YELLOW}⚡ Writing image to /dev/$disk...${NC}"
    echo -e "${CYAN}│${NC}"
    dd if=chr.img bs=1M of=/dev/$disk status=progress 2>&1 | grep --line-buffered -oP '\d+(?= bytes)' | awk '{printf("\r'${CYAN}'│'${NC}'  '${GREEN}'▶'${NC}' Writing... '${WHITE}'%d MB'${NC}' '${CYAN}'│'${NC}'"), $1/1048576}'
    echo ""
    echo -e "${CYAN}│${NC}  ${GREEN}✓${NC} Image written successfully"
    echo -e "${CYAN}└─${NC}"
    sleep 1
    
    # مرحله 9: Sync و Reboot
    show_step 9 $total_steps "Finalizing Installation" "✅"
    echo -e "${CYAN}┌─ Syncing disk...${NC}"
    echo s > /proc/sysrq-trigger 2>/dev/null
    show_progress 100 100 "Disk sync complete"
    echo ""
    echo -e "${CYAN}│${NC}  ${GREEN}✓${NC} All changes written to disk"
    echo -e "${CYAN}└─${NC}"
    sleep 1
    
    # نمایش اطلاعات نهایی
    clear
    show_banner
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                  ✅ INSTALLATION COMPLETED!                    ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${MAGENTA}╔════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║         🔐 LOGIN CREDENTIALS           ║${NC}"
    echo -e "${MAGENTA}╠════════════════════════════════════════╣${NC}"
    echo -e "${MAGENTA}║${NC} ${CYAN}Username:${NC}    ${WHITE}admin${NC}"
    echo -e "${MAGENTA}║${NC} ${CYAN}Password:${NC}    ${WHITE}$PASSWORD${NC}"
    echo -e "${MAGENTA}║${NC}"
    echo -e "${MAGENTA}║${NC} ${CYAN}IP Address:${NC}  ${WHITE}$ADDRESS${NC}"
    echo -e "${MAGENTA}║${NC} ${CYAN}Gateway:${NC}     ${WHITE}$GATEWAY${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}╔════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║          ⏳ REBOOTING IN 10s           ║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}System will reboot automatically...${NC}"
    echo ""
    
    read -t 10 -u 1
    echo ""
    echo -e "${GREEN}🔄 Rebooting now...${NC}"
    echo b > /proc/sysrq-trigger
}

# نصب خودکار
automatic_install() {
    show_banner
    echo -e "${WHITE}╔════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║${GREEN}⚡ AUTOMATIC INSTALLATION${WHITE} ║${NC}"
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
    echo -e "${WHITE}║${YELLOW}🔧 CUSTOM INSTALLATION${WHITE} ║${NC}"
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
            echo -e "${GREEN}║ Thank you for using Rapido Server CHR! ║${NC}"
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
