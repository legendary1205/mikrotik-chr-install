<div align="center">

<h1>MikroTik CHR Installer</h1>

<p>Click a button below to switch language</p>

<button onclick="document.getElementById('fa').style.display='block'; document.getElementById('en').style.display='none';">🇮🇷 فارسی</button>
<button onclick="document.getElementById('fa').style.display='none'; document.getElementById('en').style.display='block';">🇺🇸 English</button>

</div>

<style>
.lang-box {
  border: 1px solid #ccc;
  padding: 20px;
  border-radius: 10px;
  margin-top: 20px;
  font-size: 15px;
  line-height: 1.7;
}
code {
  background: #f0f0f0;
  padding: 2px 5px;
  border-radius: 4px;
}
pre {
  background: #f0f0f0;
  padding: 10px;
  border-radius: 5px;
  overflow-x: auto;
}
</style>

<!-- ========================= -->
<!-- ======= فارسی ========== -->
<!-- ========================= -->

<div id="fa" class="lang-box" style="display:none; direction: rtl; text-align: right;">

# نصب‌کننده MikroTik CHR  
این ریپازیتوری شامل دو اسکریپت حرفه‌ای برای نصب و راه‌اندازی MikroTik Cloud Hosted Router است.  
یکی کاملاً **ایمن**، و دیگری **کاملاً خودکار (خطرناک)**.

---

## ۱) safe_installer.sh  
نسخه امن — **هیچ دیسکی را حذف یا فرمت نمی‌کند**  
این نسخه:

- CHR را دانلود می‌کند  
- کارت شبکه را شناسایی می‌کند  
- IP و روت را تنظیم می‌کند  
- فایل autorun.scr می‌سازد  
- همه چیز را آماده نصب می‌کند  
- ولی **عملیات خطرناک dd را انجام نمی‌دهد**

### اجرای نسخه امن:
```bash
chmod +x safe_installer.sh
sudo ./safe_installer.sh
