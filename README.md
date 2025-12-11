(100٪ سازگار با GitHub – نسخه آخر)


نمایش کد


<div align="center">

# MikroTik CHR Installer

Select Language  
[🇺🇸 English](#english-version) | [🇮🇷 فارسی](#نسخه-فارسی)

---

### 🔥 Quick Install (Direct Link)
wget https://raw.githubusercontent.com/legendary1205/mikrotik-chr-install/main/chr_install -O chr_install

bash chr_install



</div>

---

---

# English Version


### Available Modes
1. **SAFE Mode**  
   No disk wipe. Prepares image, downloads CHR, configures network, and leaves final `dd` to you.

2. **DESTRUCTIVE Mode**  
   Fully automatic. Wipes disk, installs CHR, reboots.  
   (For advanced users only)

---



---

## 📌 1) safe_installer.sh (manual, safe)

This script:

- Downloads CHR image  
- Detects network interface  
- Configures IP & gateway  
- Creates autorun.scr  
- Prepares installation environment  
- Does **NOT** run dd  

Run:
wget https://raw.githubusercontent.com/legendary1205/mikrotik-chr-install/main/safe_installer.sh

chmod +x safe_installer.sh

sudo ./safe_installer.sh



---

## 📌 2) auto_destructive.sh (dangerous, fully automated)

This script:

- Detects target disk  
- Writes CHR using dd  
- Asks for confirmation  
- Reboots into CHR  

⚠ WARNING: Erases all data on selected disk.

Run:
wget https://raw.githubusercontent.com/legendary1205/mikrotik-chr-install/main/auto_destructive.sh

chmod +x auto_destructive.sh

sudo ./auto_destructive.sh



---

---

# نسخه فارسی

## معرفی

1. **نسخه امن (SAFE)**  
   بدون تخریب، مناسب آزمایش، آماده‌سازی شبکه و دانلود ایمیج.  

2. **نسخه تخریبی (DESTRUCTIVE)**  
   نصب کامل و خودکار — کل دیسک را پاک می‌کند.  
   فقط برای افراد حرفه‌ای.

---

## 📌 1) safe_installer.sh (نسخه امن)

این اسکریپت:

- ایمیج CHR را دانلود می‌کند  
- کارت شبکه را شناسایی می‌کند  
- IP و Gateway تنظیم می‌کند  
- فایل autorun.scr می‌سازد  
- بدون اجرای dd، سیستم را برای نصب نهایی آماده می‌کند  

اجرا:
wget https://raw.githubusercontent.com/legendary1205/mikrotik-chr-install/main/safe_installer.sh

chmod +x safe_installer.sh

sudo ./safe_installer.sh



---

## 📌 2) auto_destructive.sh (خطرناک و خودکار)

این اسکریپت:

- دیسک نصب را تشخیص می‌دهد  
- ایمیج CHR را با dd روی دیسک می‌نویسد  
- تأییدیه قطعی می‌گیرد  
- سیستم را ریبوت می‌کند  

⚠ هشدار: کل اطلاعات دیسک انتخاب‌شده پاک می‌شود.

اجرا:
wget https://raw.githubusercontent.com/legendary1205/mikrotik-chr-install/main/auto_destructive.sh

chmod +x auto_destructive.sh

sudo ./auto_destructive.sh


نمایش کد



---

<div align="center">
  
### ✨ Finished  

</div>
