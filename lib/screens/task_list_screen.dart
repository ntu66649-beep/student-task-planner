import 'package:flutter/material.dart';

import '../models/task.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [];

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
      _tasks.add(task);
      _tasks.sort((a, b) {
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
        const SnackBar(content: Text('Task added successfully.')),
      );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Task Planner')),
      body: _tasks.isEmpty
          ? const _EmptyTaskList()
          : ListView.separated(
              key: const ValueKey('taskList'),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: _tasks.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  key: ValueKey('task-${task.id}'),
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          'Deadline: ${_formatDate(task.deadline)}'
                          ' • Priority: ${task.priority.label}',
                        ),
                      ],
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
