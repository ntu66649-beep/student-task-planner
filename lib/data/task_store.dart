import '../models/task.dart';

class TaskStore {
  static final List<Task> tasks = [];

  static void addTask(Task task) {
    tasks.add(task);

    tasks.sort((a, b) {
      final byDeadline = a.deadline.compareTo(b.deadline);

      if (byDeadline != 0) {
        return byDeadline;
      }

      return a.createdAt.compareTo(b.createdAt);
    });
  }

  static void deleteTask(String id) {
    tasks.removeWhere((task) => task.id == id);
  }

  static void updateTask(Task task) {
    final index = tasks.indexWhere(
      (savedTask) => savedTask.id == task.id,
    );

    if (index != -1) {
      tasks[index] = task;
    }
  }
}