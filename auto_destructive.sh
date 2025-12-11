#!/bin/bash
set -euo pipefail

# --------------------------------------------
#  MikroTik CHR Auto Installer (Destructive)
#  WARNING: This script ERASES your primary disk!
# --------------------------------------------

if [[ $EUID -ne 0 ]]; then
    echo "You must run as root!"
    exit 1
fi

# Auto detect NIC
NET_IF=$(ip -4 -o addr show | awk '!/ lo /{print $2; exit}')
ADDRESS=$(ip -4 addr show "$NET_IF" | grep global | awk '{print $2}')
GATEWAY=$(ip route | grep default | awk '{print $3}')

# Auto detect disk (largest non-loop disk)
DISK=$(lsblk -dn -o NAME,TYPE,SIZE | awk '$2=="disk"{print $1, $3}' | sort -k2 -h | tail -n 1 | awk '{print $1}')
TARGET="/dev/$DISK"

VERSIONCHR="7.19.3"
IMAGE_URL="https://download.mikrotik.com/routeros/${VERSIONCHR}/chr-${VERSIONCHR}.img.zip"

echo "Automatic destructive installation will begin."
echo "Detected network: $NET_IF  IP: $ADDRESS  Gateway: $GATEWAY"
echo "Detected target disk: $TARGET (WILL BE ERASED)"
echo

read -rp "Type YES to continue: " OK
[[ "$OK" == "YES" ]] || exit 1

if command -v apt >/dev/null; then
    apt update && apt install -y pwgen unzip wget
elif command -v dnf >/dev/null; then
    dnf install -y pwgen unzip wget
fi

wget -4 "$IMAGE_URL" -O chr.img.zip
gunzip -c chr.img.zip > chr.img

mkdir -p /mnt/chr
mount -o loop,offset=33571840 chr.img /mnt/chr

PASSWORD=$(pwgen 12 1)
echo "RouterOS Password: $PASSWORD"

cat <<EOF > /mnt/chr/rw/autorun.scr
/ip address add address=$ADDRESS interface=[/interface ethernet find name=ether1]
/ip route add gateway=$GATEWAY
/ip dns set servers=8.8.8.8,1.1.1.1
/ip service disable telnet
/user set 0 name=admin password=$PASSWORD
EOF

umount /mnt/chr

echo "Writing CHR image to $TARGET..."
dd if=chr.img of="$TARGET" bs=4M status=progress
sync

echo "INSTALLATION COMPLETE. Rebooting..."
reboot -f
