# Kết quả kiểm thử Mobile - Student Task Planner

## TC01 - Đăng nhập với tài khoản hợp lệ

### Mục tiêu kiểm thử
Kiểm tra người dùng có thể đăng nhập thành công khi nhập đúng tài khoản.

### Dữ liệu kiểm thử
- Username: `student`
- Password: `123456`

### Các bước thực hiện
1. Mở ứng dụng Student Task Planner.
2. Nhập Username: `student`.
3. Nhập Password: `123456`.
4. Nhấn nút `LOGIN`.

### Kết quả mong đợi
- Đăng nhập thành công.
- Hệ thống chuyển sang màn hình Home Dashboard.
- Hiển thị các chức năng:
  - My Tasks
  - Add Task
  - Pending
  - Completed
  - Logout

### Kết quả thực tế
- Đăng nhập thành công.
- Hệ thống chuyển sang Home Dashboard.
- Các chức năng trên Home Dashboard hiển thị bình thường.
- Logout thành công và quay lại màn hình Login.

### Trạng thái
**PASS**

### Kiểm thử tự động
- Tool: Appium
- Driver: UiAutomator2
- Client: WebdriverIO
- Thiết bị: Pixel 7 Android Emulator
- Test script: `appium-tests/login_test.mjs`

---

## Danh sách test case tiếp theo

| ID | Test case | Trạng thái |
|---|---|---|
| TC02 | Đăng nhập sai mật khẩu | Chưa thực hiện |
| TC03 | Bỏ trống Username | Chưa thực hiện |
| TC04 | Bỏ trống Password | Chưa thực hiện |
| TC05 | Thêm Task hợp lệ | Chưa thực hiện |
| TC06 | Bỏ trống tên Task | Chưa thực hiện |
| TC07 | Đánh dấu Task hoàn thành | Chưa thực hiện |
| TC08 | Xóa Task | Chưa thực hiện |