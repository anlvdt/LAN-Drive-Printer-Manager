# LAN Drive & Printer Manager - Quản lý Chia sẻ Mạng LAN Đơn giản

Một bộ công cụ mạnh mẽ được viết bằng PowerShell và CMD giúp tự động hóa hoàn toàn quá trình chia sẻ ổ đĩa và máy in trong mạng nội bộ (LAN), dành cho cả người dùng không chuyên về kỹ thuật.

![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fale-vn%2FLANDriveManager&countColor=%23263759&style=flat)

---

## Mục lục

- [Giới thiệu](#giới-thiệu)
- [Tính năng nổi bật](#tính-năng-nổi-bật)
- [Yêu cầu hệ thống](#yêu-cầu-hệ-thống)
- [Hướng dẫn sử dụng](#hướng-dẫn-sử-dụng)
  - [Dành cho Người Chia sẻ (Máy chủ)](#dành-cho-người-chia-sẻ-máy-chủ)
  - [Dành cho Người Kết nối (Máy khách)](#dành-cho-người-kết-nối-máy-khách)
- [Cấu trúc dự án](#cấu-trúc-dự-án)
- [Đóng góp](#đóng-góp)
- [Tác giả](#tác-giả)
- [Ủng hộ dự án (Donate)](#ủng-hộ-dự-án-donate)
- [Giấy phép (License)](#giấy-phép-license)

## Giới thiệu

Việc chia sẻ một thư mục hay một chiếc máy in trong mạng LAN thường đòi hỏi nhiều bước cấu hình phức tạp qua các cửa sổ của Windows, dễ gây nhầm lẫn cho người dùng thông thường. **LAN Drive & Printer Manager** được sinh ra để giải quyết triệt để vấn đề này.

Chỉ bằng vài cú nhấp chuột, người dùng có thể chia sẻ tài nguyên và tạo ra một "gói cài đặt" nhỏ gọn để gửi cho người khác. Người nhận chỉ cần chạy một tệp duy nhất để tự động kết nối mà không cần biết bất kỳ thông tin kỹ thuật nào như tên máy chủ, địa chỉ IP hay cách cấu hình.

## Tính năng nổi bật

### Dành cho Máy chủ (Người chia sẻ)
- **Giao diện thân thiện:** Sử dụng cửa sổ đồ họa để chọn thư mục cần chia sẻ, tránh sai sót.
- **Tự động hóa toàn diện:** Tự kiểm tra và khởi động các dịch vụ hệ thống cần thiết (Server, Print Spooler).
- **Cấu hình "2 trong 1":** Tự động thiết lập cả quyền Chia sẻ Mạng (Sharing) và quyền Bảo mật NTFS.
- **Tạo gói cài đặt "Chìa khóa trao tay":** Tự động tạo một thư mục chứa script kết nối đã được cấu hình sẵn và tệp hướng dẫn đơn giản cho người dùng cuối.

### Dành cho Máy khách (Người kết nối)
- **Trải nghiệm "Một cú nhấp":** Chỉ cần chạy một tệp `.bat` duy nhất để hoàn tất mọi việc.
- **Tự chẩn đoán thông minh:**
    - Tự động kiểm tra kết nối (ping) đến máy chủ và báo lỗi rõ ràng nếu không tìm thấy.
    - Tự động tìm ký tự ổ đĩa trống (Z:, Y:, X:...) để tránh xung đột.
- **Tự cấu hình hệ thống:**
    - Tự động yêu cầu quyền Admin chỉ khi cần thiết (lần đầu tiên).
    - Tự động vô hiệu hóa IPv6 và các chính sách bảo mật ("Point and Print") để đảm bảo kết nối ổn định.
    - Sử dụng cơ chế "cờ hiệu" (flag file) đáng tin cậy để không yêu cầu khởi động lại nhiều lần.
- **Tự sửa lỗi:** Dễ dàng kết nối lại các ổ đĩa bị lỗi (dấu X đỏ) chỉ bằng cách chạy lại script.

## Yêu cầu hệ thống
- **Hệ điều hành:** Windows 10, Windows 11 (Cả bản Pro và Home).
- **Mạng:** Các máy tính phải được kết nối trong cùng một mạng LAN.
- **Quyền:** Người chia sẻ cần chạy script với quyền Administrator. Script của người kết nối sẽ tự động yêu cầu quyền khi cần.

## Hướng dẫn sử dụng

### Dành cho Người Chia sẻ (Máy chủ)

1.  **Tải về:** Tải về các tệp của dự án này.
2.  **Đặt chung thư mục:**
    - Để chia sẻ ổ đĩa, đặt 2 tệp `Chay-Tao-Chia-Se.bat` và `Tao-Chia-Se.ps1` vào cùng một thư mục.
    - Để chia sẻ máy in, đặt 2 tệp `Chay-ChiaSe-MayIn.bat` và `ChiaSe-MayIn.ps1` vào cùng một thư mục.
3.  **Chạy script:**
    - Nhấp chuột phải vào tệp `.bat` tương ứng (`Chay-Tao-Chia-Se.bat` hoặc `Chay-ChiaSe-MayIn.bat`) và chọn **"Run as administrator"**.
    - Làm theo các hướng dẫn trên màn hình (chọn thư mục/máy in, đặt tên chia sẻ...).
4.  **Gửi gói cài đặt:** Sau khi hoàn tất, một thư mục `Goi_Ket_Noi_...` sẽ được tạo trên Desktop của bạn. Hãy nén (zip) thư mục này lại và gửi cho đồng nghiệp.

### Dành cho Người Kết nối (Máy khách)

1.  **Nhận và giải nén:** Nhận tệp zip từ người chia sẻ và giải nén nó.
2.  **Chạy tệp `.bat`:** Nhấp đúp chuột vào tệp `.bat` bên trong thư mục vừa giải nén (`KetNoiOdiaMang.bat` hoặc `KetNoiMayIn.bat`).
3.  **Lần đầu tiên:** Script có thể sẽ yêu cầu quyền Administrator để cấu hình máy tính. Hãy chọn **"Yes"**. Sau đó, bạn có thể sẽ được yêu cầu **khởi động lại máy tính**.
4.  **Lần thứ hai:** Sau khi khởi động lại, hãy chạy lại tệp `.bat` một lần nữa. Lần này, script sẽ tiến hành kết nối và ổ đĩa mạng/máy in sẽ xuất hiện trên máy của bạn.

## Cấu trúc dự án

- **`Tao-ChiaSe.ps1`:** Script PowerShell chính, chứa toàn bộ logic để chia sẻ ổ đĩa và tạo gói client.
- **`Chay-Tao-Chia-Se.bat`:** Tệp CMD đơn giản để khởi chạy `Tao-ChiaSe.ps1` với quyền Admin.
- **`ChiaSe-MayIn.ps1`:** Script PowerShell chính, chứa toàn bộ logic để chia sẻ máy in và tạo gói client.
- **`Chay-ChiaSe-MayIn.bat`:** Tệp CMD đơn giản để khởi chạy `ChiaSe-MayIn.ps1` với quyền Admin.

## Đóng góp
Mọi ý kiến đóng góp, báo lỗi (issue) hay yêu cầu kéo (pull request) đều được chào đón. Nếu bạn có ý tưởng để cải thiện dự án, đừng ngần ngại tạo một issue để chúng ta cùng thảo luận.

## Tác giả

Dự án này là sản phẩm của sự hợp tác giữa:
- **Lê Ẩn:** Ý tưởng, kiểm thử và định hướng phát triển.
- **Gemini (Google AI):** Phát triển và tinh chỉnh mã nguồn.

## Ủng hộ dự án (Donate)

Nếu bạn thấy công cụ này hữu ích và muốn ủng hộ tác giả, bạn có thể gửi một khoản đóng góp nhỏ qua:
- **Ngân hàng:** MB BANK
- **Số tài khoản:** 0360126996868
- **Chủ tài khoản:** LE VAN AN

Mọi sự ủng hộ, dù nhỏ, đều là nguồn động viên to lớn để chúng tôi tiếp tục phát triển các dự án mã nguồn mở hữu ích khác.

## Giấy phép (License)
Dự án này được cấp phép theo Giấy phép MIT. Xem chi tiết tại file `LICENSE`.
