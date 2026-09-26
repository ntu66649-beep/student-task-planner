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
    this.status = false,
  });

  final String id;
  final String title;
  final String description;
  final DateTime deadline;
  final TaskPriority priority;
  final DateTime createdAt;
  final bool status;

  // Hàm copyWith giúp tạo object mới khi thay đổi trạng thái isCompleted
    Task copyWith({
      String? id,
      String? title,
      String? description,
      DateTime? deadline,
      TaskPriority? priority,
      DateTime? createdAt,
      bool? status,
    }) {
      return Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        deadline: deadline ?? this.deadline,
        priority: priority ?? this.priority,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
      );
    }
}
