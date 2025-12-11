#!/bin/bash
set -euo pipefail

# --------------------------------------------
#  MikroTik CHR Safe Installer (Non-Destructive)
#  Works on Ubuntu, Debian, CentOS, Rocky, AlmaLinux
#  Author: Sajjad
#
#  This script ONLY prepares:
#   - Network auto-detection
#   - Disk listing (NO writing)
#   - CHR image download
#   - autorun.scr generator
#
#  It DOES NOT write to disk unless user executes the final dd command manually.
# --------------------------------------------

# Detect network interface
NET_IF=$(ip -4 -o addr show | awk '!/ lo /{print $2; exit}')
ADDRESS=$(ip -4 addr show "$NET_IF" | grep global | awk '{print $2}')
GATEWAY=$(ip route | grep default | awk '{print $3}')

VERSIONCHR="7.19.3"
IMAGE_URL="https://download.mikrotik.com/routeros/${VERSIONCHR}/chr-${VERSIONCHR}.img.zip"

echo "Detected Network Interface: $NET_IF"
echo "IP Address: $ADDRESS"
echo "Gateway:    $GATEWAY"
echo

echo "Installing required packages..."
if command -v apt >/dev/null; then
    apt update && apt install -y pwgen unzip wget
elif command -v dnf >/dev/null; then
    dnf install -y pwgen unzip wget
else
    echo "Neither apt nor dnf available. Install pwgen, unzip, wget manually."
    exit 1
fi

echo "Downloading CHR image..."
wget -4 "$IMAGE_URL" -O chr.img.zip
gunzip -c chr.img.zip > chr.img

mkdir -p /mnt/chr
mount -o loop,offset=33571840 chr.img /mnt/chr

PASSWORD=$(pwgen 12 1)
echo "Generated CHR Admin Password: $PASSWORD"

# Create autorun.scr
cat <<EOF > /mnt/chr/rw/autorun.scr
/ip address add address=$ADDRESS interface=[/interface ethernet find name=ether1]
/ip route add gateway=$GATEWAY
/ip dns set servers=8.8.8.8,1.1.1.1
/ip service disable telnet
/user set 0 name=admin password=$PASSWORD
EOF

umount /mnt/chr

echo
echo "SAFE MODE COMPLETE!"
echo "Your CHR image is ready (chr.img)."
echo "Your autorun.scr is applied."
echo
echo "IMPORTANT:"
echo "This script DID NOT write anything to your disk."
echo "List your disks using:"
echo "  lsblk"
echo
echo "To install manually:"
echo "  dd if=chr.img of=/dev/sdX bs=4M status=progress && sync"
