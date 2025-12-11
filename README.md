# MikroTik CHR Installer (Safe + Auto)

This repository contains two installer scripts for MikroTik Cloud Hosted Router (CHR):

1) safe_installer.sh  
   - 100% safe  
   - Does NOT write to disk  
   - Auto-detects network  
   - Builds autorun.scr  
   - Prepares CHR image  
   - User installs manually using dd

2) auto_destructive.sh  
   - Fully automatic  
   - ERASES the primary disk  
   - Auto-detects NIC + IP + Gateway  
   - Auto-detects largest disk  
   - Applies autorun  
   - Installs CHR and reboots

---

# توضیحات فارسی

این ریپو شامل دو اسکریپت برای نصب RouterOS CHR است.

## 1) safe_installer.sh (نسخه امن)
این نسخه سیستم‌عامل فعلی را تخریب نمی‌کند.  
کارهایی که انجام می‌دهد:

- تشخیص خودکار کارت شبکه  
- تشخیص IP و Gateway  
- دانلود ایمیج CHR  
- ساخت autorun.scr  
- تغییر ندادن هیچ دیسکی  
- مناسب برای هر سیستم‌عامل (Ubuntu، Debian، CentOS، Rocky، Alma و ...)

در پایان دستور dd را نمایش می‌دهد تا خودتان اجرا کنید.

## 2) auto_destructive.sh (نسخه تخریبی و اتوماتیک)
این نسخه مناسب کاربران حرفه‌ای است.

- دیسک اصلی را پاک می‌کند  
- سیستم‌عامل فعلی را حذف می‌کند  
- نصب کامل RouterOS انجام می‌دهد  
- سپس سیستم را ریبوت می‌کند  

**اخطار: اجرای این نسخه روی هر سروری منجر به حذف کامل سیستم‌عامل میزبان می‌شود.**

---

# How to use

### Safe Version:
