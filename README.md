<div align="center">

# MikroTik CHR Installer  
Select language:

[🇺🇸 English](#english) | [🇮🇷 فارسی](#فارسی)

</div>

---

# English

This repository includes two scripts for installing MikroTik Cloud Hosted Router (CHR):

1) **safe_installer.sh**  
Safe mode — does NOT wipe disks. Prepares everything and lets you run `dd` manually.

2) **auto_destructive.sh**  
Fully automatic mode — wipes target disk and installs CHR.  
For advanced users only.

---

## 1) safe_installer.sh (safe mode)

This script:

- Downloads CHR
- Detects network interface
- Configures IP & gateway
- Creates autorun.scr
- Prepares installation  
- Does *not* run `dd` (no disk wipe)

**Run:**
```bash
wget https://github.com/legendary1205/mikrotik-chr-install/main/safe_installer.sh 
chmod +x safe_installer.sh
sudo ./safe_installer.sh
