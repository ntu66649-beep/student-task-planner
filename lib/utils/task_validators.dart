DateTime dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

String? validateTaskTitle(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Title is required.';
  }

  return null;
}

String? validateTaskDeadline(DateTime? deadline, DateTime now) {
  if (deadline == null) {
    return 'Deadline is required.';
  }

  if (dateOnly(deadline).isBefore(dateOnly(now))) {
    return 'Deadline cannot be in the past.';
  }

  return null;
}
