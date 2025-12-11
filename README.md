# Rapido MikroTik Installer | نصب خودکار میکروتیک روتر

<div align="center">

[![Language](https://img.shields.io/badge/Language-Switch-blue)](#language-switch)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![MikroTik](https://img.shields.io/badge/MikroTik-CHR-red.svg)](https://mikrotik.com)
[![Bash](https://img.shields.io/badge/Bash-4.0%2B-orange.svg)](https://www.gnu.org/software/bash/)

</div>

---

## 🌍 Language Switch

- [🇺🇸 English Version](#english-version)
- [🇮🇷 نسخه فارسی](#نسخه-فارسی)

---

<a name="english-version"></a>

# 🇺🇸 English Version

## 📖 Description

**Rapido MikroTik Installer** is an automated bash script for installing MikroTik CHR (Cloud Hosted Router) on Ubuntu/Debian servers. This script provides an easy-to-use menu interface for both automatic and custom installations.

## ✨ Features

- 🎨 Beautiful colored ASCII art menu interface
- 🚀 Automatic installation with default settings
- ⚙️ Custom installation with user-defined parameters
- 🔒 Auto-generated secure passwords
- 🌐 Automatic network configuration
- 💾 Support for different disk types (vda, sda)
- ✅ Confirmation prompts before installation
- 🎯 Error handling and validation

## 📋 Requirements

- Ubuntu or Debian-based Linux distribution
- Root access (sudo privileges)
- Active internet connection
- Minimum 1GB free disk space

## 🚀 Quick Installation

Run this one-line command to install MikroTik CHR:
```bash
wget -O - https://raw.githubusercontent.com/legendary1205/mikrotik-chr-install/main/install.sh | sudo bash

**Or** download and run manually:

bash
wget https://raw.githubusercontent.com/legendary1205/mikrotik-chr-install/main/install.sh

bash
chmod +x install.sh

bash
sudo ./install.sh

**Or** using curl:

bash
curl -O https://raw.githubusercontent.com/legendary1205/mikrotik-chr-install/main/install.sh

bash
chmod +x install.sh

bash
sudo ./install.sh

## 📝 Usage

### Menu Options

When you run the script, you'll see three options:

#### 1️⃣ **Install MikroTik Automatic**
- Uses default MikroTik version (7.19.3)
- Prompts for network interface name
- Prompts for disk name
- Requires confirmation before installation

**Example:**

Network Interface: eth0
Disk: vda
Version: 7.19.3 (default)

#### 2️⃣ **Install MikroTik Custom**
- Allows you to specify MikroTik version
- Prompts for network interface name
- Prompts for disk name
- Prompts for custom version number
- Requires confirmation before installation

**Example:**

Network Interface: ens3
Disk: sda
Version: 7.18 (your choice)

#### 3️⃣ **Exit**
- Safely exits the script

## 🔧 Configuration Details

### Network Interface
The script will ask for your network interface name. Common examples:
- `eth0`
- `ens3`
- `ens18`
- `enp0s3`

To check available interfaces:
bash
ip link show

### Disk Selection
Choose your target disk:
- `vda` - Virtual disk (common in VPS/Cloud)
- `sda` - Physical disk (common in dedicated servers)

To check available disks:
bash
lsblk

### MikroTik Version
For custom installation, you can specify any version available at [MikroTik Downloads](https://mikrotik.com/download).

Example versions:
- `7.19.3` (latest stable)
- `7.18`
- `7.17.1`
- `7.16.2`

## 🔐 Security

- The script generates a random 12-character password for the admin user
- Telnet service is automatically disabled
- Only secure SSH access is configured
- DNS servers set to 8.8.8.8 and 1.1.1.1

## ⚠️ Important Notes

- **⚠️ WARNING**: This script will completely overwrite your selected disk
- All existing data on the target disk will be lost
- Make sure to backup any important data before proceeding
- The server will automatically reboot after installation
- Save the generated password immediately after installation

## 📊 Post-Installation

After successful installation, the script will display:

Username: admin
Password: xxxxxxxxxxxx

**⚠️ IMPORTANT**: Save this password immediately! The system will reboot in 10 seconds.

### Accessing MikroTik

After reboot, connect via SSH:
bash
ssh admin@your-server-ip

Or use WinBox/WebFig:
- **WebFig**: `http://your-server-ip`
- **WinBox**: Download from [MikroTik website](https://mikrotik.com/download)

## 🐛 Troubleshooting

### Script won't run

bash
chmod +x install.sh

bash
sudo ./install.sh

### Download fails
- Check your internet connection
- Verify the MikroTik version exists on official website
- Try downloading the script again

### Installation fails
- Verify disk name is correct (`lsblk` to check)
- Ensure sufficient disk space (`df -h`)
- Check network interface name is valid (`ip link show`)
- Make sure you have root privileges

### Can't connect after installation
- Wait a few minutes for the system to fully boot
- Check if the server IP address has changed
- Verify firewall settings
- Try accessing via WebFig instead of SSH

## 📚 Additional Resources

- [MikroTik Documentation](https://help.mikrotik.com/)
- [MikroTik Wiki](https://wiki.mikrotik.com/)
- [MikroTik Forum](https://forum.mikrotik.com/)

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 Support

For issues and questions:
- Open an issue on [GitHub Issues](https://github.com/legendary1205/mikrotik-chr-install/issues)
- Check existing issues for solutions

## 🙏 Credits

- MikroTik for the CHR images
- Community contributors
- All users who provide feedback

---

<a name="نسخه-فارسی"></a>

# 🇮🇷 نسخه فارسی

## 📖 توضیحات

**نصب‌کننده خودکار میکروتیک راپیدو** یک اسکریپت bash خودکار برای نصب MikroTik CHR (Cloud Hosted Router) بر روی سرورهای Ubuntu/Debian است. این اسکریپت یک رابط منوی کاربرپسند برای نصب خودکار و سفارشی ارائه می‌دهد.

## ✨ امکانات

- 🎨 رابط منوی رنگی و زیبا با ASCII Art
- 🚀 نصب خودکار با تنظیمات پیش‌فرض
- ⚙️ نصب سفارشی با پارامترهای دلخواه کاربر
- 🔒 تولید خودکار رمز عبور امن
- 🌐 پیکربندی خودکار شبکه
- 💾 پشتیبانی از انواع دیسک (vda, sda)
- ✅ درخواست تأیید قبل از نصب
- 🎯 مدیریت خطا و اعتبارسنجی

## 📋 پیش‌نیازها

- سیستم عامل Ubuntu یا Debian
- دسترسی Root (مجوز sudo)
- اتصال فعال به اینترنت
- حداقل 1 گیگابایت فضای خالی دیسک

## 🚀 نصب سریع

با اجرای این دستور یک خطی، میکروتیک CHR را نصب کنید:

bash
wget -O - https://raw.githubusercontent.com/legendary1205/mikrotik-chr-install/main/install.sh | sudo bash

**یا** به صورت دستی دانلود و اجرا کنید:

bash
wget https://raw.githubusercontent.com/legendary1205/mikrotik-chr-install/main/install.sh

bash
chmod +x install.sh

bash
sudo ./install.sh

**یا** با استفاده از curl:

bash
curl -O https://raw.githubusercontent.com/legendary1205/mikrotik-chr-install/main/install.sh

bash
chmod +x install.sh

bash
sudo ./install.sh

## 📝 نحوه استفاده

### گزینه‌های منو

هنگام اجرای اسکریپت، سه گزینه مشاهده خواهید کرد:

#### 1️⃣ **نصب خودکار میکروتیک**
- از نسخه پیش‌فرض میکروتیک (7.19.3) استفاده می‌کند
- نام کارت شبکه را درخواست می‌کند
- نام دیسک را درخواست می‌کند
- قبل از نصب نیاز به تأیید دارد

**مثال:**

کارت شبکه: eth0
دیسک: vda
نسخه: 7.19.3 (پیش‌فرض)

#### 2️⃣ **نصب سفارشی میکروتیک**
- امکان تعیین نسخه دلخواه میکروتیک
- نام کارت شبکه را درخواست می‌کند
- نام دیسک را درخواست می‌کند
- شماره نسخه سفارشی را درخواست می‌کند
- قبل از نصب نیاز به تأیید دارد

**مثال:**

کارت شبکه: ens3
دیسک: sda
نسخه: 7.18 (انتخاب شما)

#### 3️⃣ **خروج**
- خروج ایمن از اسکریپت

## 🔧 جزئیات پیکربندی

### کارت شبکه
اسکریپت نام کارت شبکه شما را درخواست می‌کند. نمونه‌های رایج:
- `eth0`
- `ens3`
- `ens18`
- `enp0s3`

برای بررسی کارت‌های موجود:
bash
ip link show

### انتخاب دیسک
دیسک مقصد خود را انتخاب کنید:
- `vda` - دیسک مجازی (رایج در VPS/Cloud)
- `sda` - دیسک فیزیکی (رایج در سرورهای اختصاصی)

برای بررسی دیسک‌های موجود:
bash
lsblk

### نسخه میکروتیک
برای نصب سفارشی، می‌توانید هر نسخه‌ای که در [دانلودهای میکروتیک](https://mikrotik.com/download) موجود است را مشخص کنید.

نمونه نسخه‌ها:
- `7.19.3` (آخرین نسخه پایدار)
- `7.18`
- `7.17.1`
- `7.16.2`

## 🔐 امنیت

- اسکریپت یک رمز عبور تصادفی 12 کاراکتری برای کاربر admin تولید می‌کند
- سرویس Telnet به طور خودکار غیرفعال می‌شود
- فقط دسترسی امن SSH پیکربندی می‌شود
- سرورهای DNS روی 8.8.8.8 و 1.1.1.1 تنظیم می‌شود

## ⚠️ نکات مهم

- **⚠️ هشدار**: این اسکریپت دیسک انتخابی شما را به طور کامل بازنویسی می‌کند
- تمام اطلاعات موجود روی دیسک مقصد از بین خواهد رفت
- قبل از ادامه، حتماً از اطلاعات مهم خود نسخه پشتیبان تهیه کنید
- سرور پس از نصب به طور خودکار ریبوت می‌شود
- رمز عبور تولید شده را بلافاصله پس از نصب ذخیره کنید

## 📊 پس از نصب

پس از نصب موفق، اسکریپت اطلاعات زیر را نمایش می‌دهد:

نام کاربری: admin
رمز عبور: xxxxxxxxxxxx

**⚠️ مهم**: این رمز عبور را فوراً ذخیره کنید! سیستم در 10 ثانیه ریبوت می‌شود.

### دسترسی به میکروتیک

پس از ریبوت، از طریق SSH متصل شوید:
bash
ssh admin@your-server-ip

یا از WinBox/WebFig استفاده کنید:
- **WebFig**: `http://your-server-ip`
- **WinBox**: از [وبسایت میکروتیک](https://mikrotik.com/download) دانلود کنید

## 🐛 عیب‌یابی

### اسکریپت اجرا نمی‌شود

bash
chmod +x install.sh

bash
sudo ./install.sh

### دانلود با خطا مواجه می‌شود
- اتصال اینترنت خود را بررسی کنید
- وجود نسخه میکروتیک را در وبسایت رسمی تأیید کنید
- دوباره اسکریپت را دانلود کنید

### نصب با خطا مواجه می‌شود
- صحت نام دیسک را بررسی کنید (`lsblk` برای چک کردن)
- فضای کافی دیسک را اطمینان حاصل کنید (`df -h`)
- معتبر بودن نام کارت شبکه را چک کنید (`ip link show`)
- مطمئن شوید دسترسی root دارید

### بعد از نصب نمی‌توانم وصل شوم
- چند دقیقه صبر کنید تا سیستم کاملاً بوت شود
- بررسی کنید که آیا آدرس IP سرور تغییر کرده است
- تنظیمات فایروال را بررسی کنید
- به جای SSH از WebFig استفاده کنید

## 📚 منابع اضافی

- [مستندات میکروتیک](https://help.mikrotik.com/)
- [ویکی میکروتیک](https://wiki.mikrotik.com/)
- [انجمن میکروتیک](https://forum.mikrotik.com/)

## 📜 مجوز

این پروژه تحت مجوز MIT منتشر شده است - برای جزئیات فایل LICENSE را ببینید.

## 🤝 مشارکت

مشارکت شما خوشآمد است! لطفاً با خیال راحت Pull Request ارسال کنید.

1. مخزن را Fork کنید
2. شاخه ویژگی خود را ایجاد کنید (`git checkout -b feature/AmazingFeature`)
3. تغییرات خود را Commit کنید (`git commit -m 'Add some AmazingFeature'`)
4. به شاخه Push کنید (`git push origin feature/AmazingFeature`)
5. یک Pull Request باز کنید

## 📞 پشتیبانی

برای مشکلات و سؤالات:
- یک issue در [GitHub Issues](https://github.com/legendary1205/mikrotik-chr-install/issues) باز کنید
- issue‌های موجود را برای راه‌حل بررسی کنید

## 🙏 قدردانی

- میکروتیک برای ایمیج‌های CHR
- مشارکت‌کنندگان جامعه
- تمام کاربرانی که بازخورد ارائه می‌دهند

---

<div align="center">

**Made with ❤️ for the MikroTik Community**

**ساخته شده با ❤️ برای جامعه میکروتیک**

### ⭐ If you find this useful, please star the repo!
### ⭐ اگر این پروژه برایتان مفید بود، لطفاً ستاره بدهید!

[⬆ Back to top | بازگشت به بالا](#rapido-mikrotik-installer--نصب-خودکار-میکروتیک-روتر)

</div>



