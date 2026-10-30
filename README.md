# Student Task Planner

## SWT301 - Mobile Testing Project

**Topic chính:** Mobile Testing  
**Nhóm:** 5 thành viên  
**Thời gian dự kiến:** khoảng 10 tuần  
**Nền tảng chính:** Android Mobile App  
**Framework:** Flutter  
**Ngôn ngữ:** Dart  
**Automation Testing:** Appium + UiAutomator2 + Appium Inspector

---

## 1. Mục tiêu project

Student Task Planner là ứng dụng giúp sinh viên quản lý công việc học tập, deadline, mức độ ưu tiên và trạng thái hoàn thành.

Project này được dùng xuyên suốt cho môn **SWT301 - Mobile Testing**, bao gồm:

- Requirement
- Test Scenario
- Test Case
- Manual Testing
- Bug Report
- Regression Testing
- Appium Automation Testing
- Final Demo

---

## 2. Trạng thái hiện tại

Repository hiện mới có **Flutter project khung mặc định**.

Mục tiêu ngắn hạn là làm một **MVP chạy được trong tuần này** để demo cho giảng viên.

### MVP tuần đầu
- Task List
- Add Task
- Mark Task Completed
- Delete Task

Nếu kịp:
- Edit Task
- Deadline
- Priority
- Search

---

## 3. Thành viên mới vào repo cần làm gì?

Sau khi Accept Invitation:

### Bước 1 - Clone repository

```bash
git clone <repository-url>
cd student-task-planner
```

Có thể dùng GitHub Desktop nếu không muốn dùng Git CLI.

### Bước 2 - Kiểm tra Flutter

```bash
flutter --version
flutter doctor
```

### Bước 3 - Lấy package

```bash
flutter pub get
```

### Bước 4 - Mở Android Emulator hoặc kết nối Android Device

```bash
flutter devices
```

### Bước 5 - Chạy project

```bash
flutter run
```

Nếu chạy thành công, Flutter app mặc định sẽ xuất hiện trên Android Emulator / Android Device.

> Nếu gặp lỗi, gửi ảnh lỗi vào nhóm để xử lý. Không tự sửa hàng loạt thứ khi chưa rõ nguyên nhân.

---

## 4. Môi trường cần cài

### Development
- Git
- Flutter SDK
- Dart
- Android Studio
- Android SDK
- Android Emulator
- GitHub account
- Một IDE / Editor:
  - Antigravity
  - VS Code
  - Android Studio

### Automation Testing
- Node.js
- npm
- Appium
- UiAutomator2
- Appium Inspector

### Kiểm tra nhanh

```bash
git --version
flutter --version
flutter doctor
adb version
node -v
npm -v
appium -v
```

---

## 5. Công nghệ chung

Ứng dụng dùng:

```text
Flutter + Dart
```

IDE mỗi người có thể khác nhau. GitHub là nơi lưu và đồng bộ source code chung.

---

## 6. Quy tắc GitHub

### Không code trực tiếp trên `main`

Mỗi chức năng làm trên branch riêng.

Ví dụ:

```text
main
├── feature/task-list
├── feature/add-task
├── feature/task-status
├── feature/ui-deadline
└── feature/appium-demo
```

### Workflow

```text
Pull code mới
↓
Tạo / checkout branch riêng
↓
Code
↓
Test trên máy
↓
Commit
↓
Push
↓
Pull Request
↓
Review
↓
Merge vào main
```

### Commit message nên rõ ràng

Ví dụ tốt:

```text
Create task list screen
Add task validation
Implement delete task
Fix completed task status
```

Không nên:

```text
update
fix
abc
final
final2
```

---

## 7. Quy tắc Week 1

> **CHẠY ĐƯỢC TRƯỚC - PHÁT TRIỂN SÂU SAU**

Mỗi thành viên cần:

1. Accept GitHub invitation
2. Clone repository
3. Setup Flutter / Android
4. Chạy được project hiện tại
5. Báo đã sẵn sàng
6. Nhận phần chức năng MVP
7. Làm trên branch riêng
8. Push code đúng quy trình

---

## 8. Scope dài hạn dự kiến

Sau khi demo và nhận feedback từ giảng viên:

- Login / Logout
- Task List
- Add Task
- Edit Task
- Delete Task
- Completed / Pending
- Deadline
- Priority
- Search
- Filter
- Overdue
- Persistent Storage

### Bonus
- Notification
- Register
- Forgot Password
- Dark Mode
- Firebase / Cloud Sync

---

## 9. Mobile Testing

Mỗi chức năng sau này phải có test case.

Ví dụ Add Task:

```text
TC01 - Add Task hợp lệ
TC02 - Title trống
TC03 - Deadline trống
TC04 - Deadline quá khứ
TC05 - Nhấn Save nhiều lần
```

Mục tiêu cuối project:

```text
Requirement
↓
Development
↓
Test Scenario
↓
Test Case
↓
Manual Testing
↓
Bug
↓
Fix
↓
Regression
↓
Appium Automation
↓
Final Demo
```

---

## 10. Lưu ý cho cả nhóm

- Ai chưa setup được thì báo sớm.
- Không đợi tới ngày demo mới cài môi trường.
- Không tự ý mở rộng scope.
- Không giữ code riêng quá lâu ngoài GitHub.
- Trước khi tạo Pull Request phải tự chạy và test chức năng trên máy.
- Nếu chưa rõ việc gì cần làm, hỏi trong nhóm trước khi sửa `main`.

---

## 11. Mục tiêu gần nhất

### Mốc 1
Tất cả thành viên:
- Accept invitation
- Clone repo
- Chạy được Flutter project

### Mốc 2
Chia 5 phần MVP

### Mốc 3
Ghép code vào `main`

### Mốc 4
Chạy demo trên Android Emulator

### Mốc 5
Nếu kịp: thử Appium Inspector nhận diện UI


## StudyFlow shared interface

The login and workspace now use the common StudyFlow design across all seven projects. See [STUDYFLOW_SYNC.md](STUDYFLOW_SYNC.md) for the palette, preserved testing behavior, run instructions and verification limits.
