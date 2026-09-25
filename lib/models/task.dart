enum TaskPriority { low, medium, high }

extension TaskPriorityLabel on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }
}

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.deadline,
    required this.priority,
    this.description = '',
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final DateTime deadline;
  final TaskPriority priority;
  final DateTime createdAt;
}
