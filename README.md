# LAN Drive & Printer Manager

Quản lý Chia sẻ Mạng LAN Đơn giản / Simple LAN Sharing Manager

Một bộ công cụ mạnh mẽ được viết bằng PowerShell và CMD giúp tự động hóa hoàn toàn quá trình chia sẻ ổ đĩa và máy in trong mạng nội bộ (LAN), dành cho cả người dùng không chuyên về kỹ thuật.

A powerful set of tools written in PowerShell and CMD that fully automates the process of sharing drives and printers on a local network (LAN), designed for non-technical users.

---

## Giới thiệu / Introduction

Việc chia sẻ một thư mục hay một chiếc máy in trong mạng LAN thường đòi hỏi nhiều bước cấu hình phức tạp. **LAN Drive & Printer Manager** được sinh ra để giải quyết triệt để vấn đề này.

Chỉ bằng vài cú nhấp chuột, người dùng có thể chia sẻ tài nguyên và tạo ra một "gói cài đặt" nhỏ gọn để gửi cho người khác.

---

## Tính năng / Features

### Dành cho Máy chủ / For Server (Sharer)
- Giao diện thân thiện với cửa sổ đồ họa
- Tự động hóa toàn diện (Server, Print Spooler services)
- Cấu hình "2 trong 1": Sharing + NTFS permissions
- Tạo gói cài đặt "Chìa khóa trao tay"

### Dành cho Máy khách / For Client (Connector)
- Trải nghiệm "Một cú nhấp" - chỉ cần chạy 1 file .bat
- Tự chẩn đoán thông minh (ping, tìm ký tự ổ đĩa trống)
- Tự cấu hình hệ thống (IPv6, Point and Print policies)
- Tự sửa lỗi ổ đĩa bị disconnect (dấu X đỏ)

---

## Yêu cầu / Requirements

- **Hệ điều hành / OS:** Windows 10, Windows 11 (Pro và Home)
- **Mạng / Network:** Các máy phải cùng mạng LAN
- **Quyền / Permissions:** Administrator cho người chia sẻ

---

## Cách sử dụng / How to Use

### Người Chia sẻ / Sharer
1. Tải về các tệp của dự án
2. Chạy `Chay-Tao-Chia-Se.bat` hoặc `Chay-ChiaSe-MayIn.bat` với quyền Admin
3. Làm theo hướng dẫn trên màn hình
4. Gửi thư mục `Goi_Ket_Noi_...` cho người kết nối

### Người Kết nối / Connector
1. Nhận và giải nén file zip
2. Chạy file `.bat` bên trong
3. Lần đầu: Cho phép quyền Admin và khởi động lại nếu được yêu cầu
4. Lần thứ hai: Chạy lại để hoàn tất kết nối

---

## Cấu trúc / Project Structure

```
LAN-Drive-Printer-Manager/
├── Tao-ChiaSe.ps1           # Script chia sẻ ổ đĩa
├── Chay-Tao-Chia-Se.bat     # Launcher cho ổ đĩa
├── ChiaSe-MayIn.ps1         # Script chia sẻ máy in
└── Chay-ChiaSe-MayIn.bat    # Launcher cho máy in
```

---

## Tác giả / Author

**Le Van An** (LAPTOP LE AN)

[![GitHub](https://img.shields.io/badge/GitHub-@anlvdt-181717?style=for-the-badge&logo=github)](https://github.com/anlvdt)
[![Facebook](https://img.shields.io/badge/Facebook-Laptop%20Le%20An-1877F2?style=for-the-badge&logo=facebook&logoColor=white)](https://www.facebook.com/laptopleandotcom)

---

## Đóng góp / Contributing

Mọi ý kiến đóng góp, báo lỗi (issue) hay pull request đều được chào đón.

All contributions, bug reports (issues), and pull requests are welcome.

---

## Ủng hộ tác giả / Support the Developer

Nếu bạn thấy công cụ này hữu ích, hãy cân nhắc ủng hộ tác giả:

If you find this tool useful, please consider supporting the developer:

[![Sponsor](https://img.shields.io/badge/Sponsor-EA4AAA?style=for-the-badge&logo=github-sponsors&logoColor=white)](https://github.com/sponsors/anlvdt)
[![Shopee](https://img.shields.io/badge/Shopee-EE4D2D?style=for-the-badge&logo=shopee&logoColor=white)](https://collshp.com/laptopleandotcom?view=storefront)

| Phương thức / Method | Số tài khoản / Account | Tên / Name |
|---------------------|------------------------|------------|
| **MB Bank** | `0360126996868` | LE VAN AN |
| **Momo** | `0976896621` | LE VAN AN |

---

## Giấy phép / License

MIT License
