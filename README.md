<div align="center">

# 🚀 Rapido MikroTik Installer

[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![MikroTik](https://img.shields.io/badge/MikroTik-CHR-red.svg)](https://mikrotik.com)
[![Bash](https://img.shields.io/badge/Bash-4.0%2B-orange.svg)](https://www.gnu.org/software/bash/)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue.svg)](https://github.com/legendary1205/mikrotik-chr-install)

### Automated MikroTik CHR Installation Script for Ubuntu/Debian

[🇺🇸 English](README.md) | [🇮🇷 فارسی](README.fa.md)

</div>

---

## 📖 Overview

**Rapido MikroTik Installer** is a powerful bash script that automates the installation of MikroTik CHR (Cloud Hosted Router) on Ubuntu/Debian systems. With an intuitive menu interface, it simplifies the deployment process for both beginners and advanced users.

## ✨ Features

- 🎨 **Beautiful Menu Interface** - Colored ASCII art with turquoise theme
- 🚀 **Automatic Installation** - One-click setup with default settings
- ⚙️ **Custom Installation** - Full control over version and configuration
- 🔒 **Auto-Generated Passwords** - Secure 12-character random passwords
- 🌐 **Network Auto-Detection** - Automatic IP and gateway configuration
- 💾 **Multi-Disk Support** - Works with VDA, SDA, and other disk types
- ✅ **Safety Confirmations** - Multiple validation prompts
- 🎯 **Error Handling** - Comprehensive validation and error checks

## 🚀 Quick Start

Install with a single command:
```bash
wget -O - https://raw.githubusercontent.com/legendary1205/mikrotik-chr-install/main/install.sh | sudo bash

## 📋 Requirements

- Ubuntu/Debian-based distribution
- Root access (sudo)
- Active internet connection
- Minimum 1GB free disk space

## 📦 Installation Methods

### Method 1: Direct Install (Recommended)

bash
wget -O - https://raw.githubusercontent.com/legendary1205/mikrotik-chr-install/main/install.sh | sudo bash

### Method 2: Download and Run

**Step 1:** Download the script

bash
wget https://raw.githubusercontent.com/legendary1205/mikrotik-chr-install/main/install.sh

**Step 2:** Make it executable

bash
chmod +x install.sh

**Step 3:** Run the installer

bash
sudo ./install.sh

### Method 3: Using curl

**Step 1:** Download with curl

bash
curl -O https://raw.githubusercontent.com/legendary1205/mikrotik-chr-install/main/install.sh

**Step 2:** Add execute permission

bash
chmod +x install.sh

**Step 3:** Execute the script

bash
sudo ./install.sh

## 🎮 Usage

After running the script, you'll see three options:

### 1️⃣ Automatic Installation
- Uses MikroTik version 7.19.3 (default)
- Asks for network interface (e.g., `eth0`, `ens3`)
- Asks for disk name (e.g., `vda`, `sda`)
- Requires final confirmation

### 2️⃣ Custom Installation
- Choose your preferred MikroTik version
- Specify network interface
- Specify target disk
- Full control over installation parameters

### 3️⃣ Exit
- Safely exit the installer

## 🔧 Configuration Guide

### Network Interface Detection

Check available interfaces:

bash
ip link show

Common interface names:
- `eth0` - Traditional naming
- `ens3`, `ens18` - Predictable naming
- `enp0s3` - PCI-based naming

### Disk Selection

List available disks:

bash
lsblk

Common disk types:
- `vda` - Virtual disk (VPS/Cloud)
- `sda` - Physical disk (Dedicated servers)
- `nvme0n1` - NVMe SSD

### MikroTik Versions

Available versions at [MikroTik Downloads](https://mikrotik.com/download):
- `7.19.3` - Latest stable (default)
- `7.18` - Previous stable
- `7.17.1` - LTS version

## ⚠️ Important Warnings

> **🚨 CRITICAL**: This script will completely overwrite your selected disk!
> 
> - All data on the target disk will be permanently lost
> - Backup important data before proceeding
> - The server will automatically reboot after installation
> - Save the generated password immediately

## 🔐 Security Features

- **Random Password Generation** - 12-character secure passwords
- **Telnet Disabled** - Only SSH access enabled
- **Secure DNS** - Configured with 8.8.8.8 and 1.1.1.1
- **Firewall Ready** - Basic security configuration applied

## 📊 Post-Installation

After successful installation, you'll receive:


═══════════════════════════════════════════
Installation Complete!
═══════════════════════════════════════════
Username: admin
Password: AbCd1234XyZ#
═══════════════════════════════════════════
⚠️  SAVE THIS PASSWORD NOW!
Server will reboot in 10 seconds...
═══════════════════════════════════════════

### Accessing Your Router

**Via SSH:**

bash
ssh admin@your-server-ip

**Via WebFig:**


http://your-server-ip

**Via WinBox:**  
Download from [MikroTik official site](https://mikrotik.com/download)

## 🐛 Troubleshooting

<details>
<summary><b>Script won't execute</b></summary>

Make sure it's executable:

bash
chmod +x install.sh

bash
sudo ./install.sh
</details>

<details>
<summary><b>Download fails</b></summary>

Check:
- Internet connection
- MikroTik version availability
- Firewall settings blocking downloads
</details>

<details>
<summary><b>Installation fails</b></summary>

Verify correct disk name:

bash
lsblk

Check disk space:

bash
df -h

Verify network interface:

bash
ip link show
</details>

<details>
<summary><b>Can't connect after reboot</b></summary>

Wait and check:
- Allow 2-3 minutes for full boot
- Verify server IP hasn't changed
- Check firewall rules
- Try WebFig as alternative
</details>

## 📚 Resources

- [MikroTik Documentation](https://help.mikrotik.com/)
- [MikroTik Wiki](https://wiki.mikrotik.com/)
- [Community Forum](https://forum.mikrotik.com/)
- [Training Courses](https://mikrotik.com/training)

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💝 Support the Project

If you find this project helpful, consider:

- ⭐ Starring the repository
- 🐛 Reporting bugs
- 💡 Suggesting new features
- 🔀 Contributing code

## 📞 Support & Contact

- **Issues**: [GitHub Issues](https://github.com/legendary1205/mikrotik-chr-install/issues)
- **Discussions**: [GitHub Discussions](https://github.com/legendary1205/mikrotik-chr-install/discussions)

## 🙏 Acknowledgments

- MikroTik for CHR images
- Community contributors
- All users providing feedback

---

<div align="center">

**Made with ❤️ for the MikroTik Community**

[⬆ Back to Top](#-rapido-mikrotik-installer)

</div>
