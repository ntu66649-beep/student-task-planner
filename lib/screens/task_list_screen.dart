import 'package:flutter/material.dart';

import '../models/task.dart';
import 'add_task_screen.dart';

/*
(noted cho branch feature/task-actions)
Những sửa đổi được thêm trong file này:

Thêm Checkbox (leading): Đổi trạng thái status giữa true / false. Khi được tích, chữ tiêu đề sẽ tự động bị gạch ngang (TextDecoration.lineThrough).
Thêm Icon Thùng rác (trailing): Khi nhấn vào sẽ gọi hàm _showDeleteConfirmDialog.
Tạo Dialog AlertDialog xác nhận xóa: Có nút "Hủy" và nút "Xóa". Bấm "Xóa" mới tiến hành loại bỏ task khỏi danh sách.
Thêm Key cho Appium: Đã gán sẵn các ValueKey như checkbox-task-${task.id}, delete-task-${task.id}, btn_confirm_delete để phục vụ công đoạn viết Automation Test sau này!
Hỗ trợ filterStatus: Cho phép lọc hiển thị Pending (false), Completed (true) hoặc All (null).
*/

class TaskListScreen extends StatefulWidget {
  final bool? filterStatus; // null: tất cả, false: pending, true: completed
  const TaskListScreen({super.key, this.filterStatus});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Giữ task khi thoát My Tasks rồi mở lại.
  // Dữ liệu vẫn tồn tại trong suốt phiên chạy của app.
  static final List<Task> _savedTasks = [];

  // Lọc danh sách task dựa trên filterStatus được truyền vào
  List<Task> get _displayTasks {
    if (widget.filterStatus == null) {
      return _savedTasks;
    }
    return _savedTasks.where((task) => task.status == widget.filterStatus).toList();
  }

  Future<void> _openAddTask() async {
    final task = await Navigator.of(context).push<Task>(
      MaterialPageRoute<Task>(
        builder: (_) => const AddTaskScreen(),
      ),
    );

    if (task == null || !mounted) {
      return;
    }

    setState(() {
      _savedTasks.add(task);

      _savedTasks.sort((a, b) {
        final byDeadline = a.deadline.compareTo(b.deadline);

        if (byDeadline != 0) {
          return byDeadline;
        }

        return a.createdAt.compareTo(b.createdAt);
      });
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Task added successfully.'),
        ),
      );
  }

  // Cập nhật trạng thái Task dựa theo ID (tránh nhầm chỉ số index khi bị lọc)
  void _toggleTaskStatus(Task task, bool? newValue) {
    setState(() {
      final index = _savedTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _savedTasks[index] = task.copyWith(
          status: newValue ?? false,
        );
      }
    });
  }

  // Hiển thị Hộp thoại Xác nhận Xóa Task dựa theo ID
  void _showDeleteConfirmDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa task "${task.title}" không?'),
          actions: [
            TextButton(
              key: const ValueKey('btn_cancel_delete'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              key: const ValueKey('btn_confirm_delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  _savedTasks.removeWhere((t) => t.id == task.id);
                });
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Task deleted successfully.'),
                    ),
                  );
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  String get _appBarTitle {
    if (widget.filterStatus == false) return 'Pending Tasks';
    if (widget.filterStatus == true) return 'Completed Tasks';
    return 'Tasks List';
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _displayTasks; // Lấy danh sách đã qua bộ lọc

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
      ),

      body: tasks.isEmpty
          ? const _EmptyTaskList()
          : ListView.separated(
              key: const ValueKey('taskList'),
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                96,
              ),
              itemCount: tasks.length, // Đổi từ _tasks.length -> tasks.length
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final task = tasks[index]; // Đổi từ _tasks[index] -> tasks[index]

                return Card(
                  key: ValueKey('task-${task.id}'),
                  child: ListTile(
                    // 1. CHỨC NĂNG COMPLETE / PENDING
                    leading: Checkbox(
                      key: ValueKey('checkbox-task-${task.id}'),
                      value: task.status,
                      onChanged: (bool? newValue) {
                        _toggleTaskStatus(task, newValue);
                      },
                    ),

                    // Tiêu đề Task: Gạch ngang nếu task đã hoàn thành
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.status
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: task.status ? Colors.grey : Colors.black,
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: task.status ? Colors.grey : Colors.black87,
                            ),
                          ),
                        ],

                        const SizedBox(height: 4),

                        Text(
                          'Deadline: ${_formatDate(task.deadline)}'
                          ' • Priority: ${task.priority.label}',
                          style: TextStyle(
                            color: task.status ? Colors.grey : Colors.black54,
                          ),
                        ),
                      ],
                    ),

                    // 2. CHỨC NĂNG DELETE
                    trailing: IconButton(
                      key: ValueKey('delete-task-${task.id}'),
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        _showDeleteConfirmDialog(context, task);
                      },
                    ),

                    isThreeLine: task.description.isNotEmpty,
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('addTaskButton'),
        onPressed: _openAddTask,
        tooltip: 'Add Task',
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}

class _EmptyTaskList extends StatelessWidget {
  const _EmptyTaskList();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.checklist_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap “Add Task” to create your first study task.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}