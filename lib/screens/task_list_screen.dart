import 'package:flutter/material.dart';

import '../models/task.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  // null = All, false = Pending, true = Completed
  final bool? filterStatus;

  const TaskListScreen({
    super.key,
    this.filterStatus,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Keep tasks during the current app session.
  static final List<Task> _savedTasks = [];

  // Filter tasks based on the selected status.
  List<Task> get _displayTasks {
    if (widget.filterStatus == null) {
      return _savedTasks;
    }

    return _savedTasks
        .where(
          (task) => task.status == widget.filterStatus,
        )
        .toList();
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

  // Toggle between Pending and Completed.
  void _toggleTaskStatus(
    Task task,
    bool? newValue,
  ) {
    setState(() {
      final index = _savedTasks.indexWhere(
        (savedTask) => savedTask.id == task.id,
      );

      if (index != -1) {
        _savedTasks[index] = task.copyWith(
          status: newValue ?? false,
        );
      }
    });
  }

  // Show confirmation dialog before deleting a task.
  void _showDeleteConfirmDialog(
    BuildContext context,
    Task task,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Task'),

          content: Text(
            'Are you sure you want to delete task "${task.title}"?',
          ),

          actions: [
            TextButton(
              key: const ValueKey(
                'btn_cancel_delete',
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              key: const ValueKey(
                'btn_confirm_delete',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  _savedTasks.removeWhere(
                    (savedTask) =>
                        savedTask.id == task.id,
                  );
                });

                Navigator.of(dialogContext).pop();

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Task deleted successfully.',
                      ),
                    ),
                  );
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final day =
        date.day.toString().padLeft(2, '0');

    final month =
        date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  String get _appBarTitle {
    if (widget.filterStatus == false) {
      return 'Pending Tasks';
    }

    if (widget.filterStatus == true) {
      return 'Completed Tasks';
    }

    return 'Tasks List';
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _displayTasks;

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
      ),

      body: tasks.isEmpty
          ? const _EmptyTaskList()
          : ListView.separated(
              key: const ValueKey(
                'taskList',
              ),
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                96,
              ),
              itemCount: tasks.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(
                height: 8,
              ),
              itemBuilder: (
                context,
                index,
              ) {
                final task = tasks[index];

                return Card(
                  key: ValueKey(
                    'task-${task.id}',
                  ),
                  child: ListTile(
                    // ==================================
                    // COMPLETE / PENDING
                    // ==================================

                    leading: Semantics(
                      label: 'Toggle ${task.title}',
                      button: true,
                      child: Checkbox(
                        key: ValueKey(
                          'checkbox-task-${task.id}',
                        ),
                        value: task.status,
                        onChanged: (
                          bool? newValue,
                        ) {
                          _toggleTaskStatus(
                            task,
                            newValue,
                          );
                        },
                      ),
                    ),

                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration:
                            task.status
                                ? TextDecoration
                                    .lineThrough
                                : TextDecoration
                                    .none,
                        color: task.status
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        if (task.description
                            .isNotEmpty) ...[
                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            task.description,
                            maxLines: 2,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style: TextStyle(
                              color:
                                  task.status
                                      ? Colors.grey
                                      : Colors
                                          .black87,
                            ),
                          ),
                        ],

                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          'Deadline: ${_formatDate(task.deadline)}'
                          ' • Priority: ${task.priority.label}',
                          style: TextStyle(
                            color: task.status
                                ? Colors.grey
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),

                    // ==================================
                    // DELETE
                    // ==================================

                    trailing: Semantics(
                      label: 'Delete ${task.title}',
                      button: true,
                      child: IconButton(
                        key: ValueKey(
                          'delete-task-${task.id}',
                        ),
                        tooltip:
                            'Delete ${task.title}',
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _showDeleteConfirmDialog(
                            context,
                            task,
                          );
                        },
                      ),
                    ),

                    isThreeLine:
                        task.description.isNotEmpty,
                  ),
                );
              },
            ),

      floatingActionButton:
          FloatingActionButton.extended(
        key: const ValueKey(
          'addTaskButton',
        ),
        onPressed: _openAddTask,
        tooltip: 'Add Task',
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Add Task',
        ),
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
        padding:
            const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons.checklist_rounded,
              size: 64,
              color:
                  Theme.of(context)
                      .colorScheme
                      .primary,
            ),

            const SizedBox(
              height: 16,
            ),

            Text(
              'No tasks yet',
              style:
                  Theme.of(context)
                      .textTheme
                      .titleLarge,
            ),

            const SizedBox(
              height: 8,
            ),

            const Text(
              'Tap “Add Task” to create your first study task.',
              textAlign:
                  TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}