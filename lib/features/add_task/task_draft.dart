/// Dữ liệu gửi từ form Add Task sang nơi lưu task chung của nhóm.
class TaskDraft {
  const TaskDraft({required this.title, required this.deadline});

  final String title;
  final DateTime deadline;
}

class AddTaskValidation {
  static String? title(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a task title.';
    }
    return null;
  }

  static DateTime dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static String? deadline(DateTime? value, {DateTime? now}) {
    if (value == null) return 'Please select a deadline.';
    if (dateOnly(value).isBefore(dateOnly(now ?? DateTime.now()))) {
      return 'Deadline cannot be in the past.';
    }
    return null;
  }
}
