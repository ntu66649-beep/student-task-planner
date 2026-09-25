import 'package:flutter/material.dart';

import 'features/add_task/add_task_screen.dart';
import 'features/add_task/task_draft.dart';

void main() => runApp(const AddTaskDemoApp());

/// Điểm chạy riêng cho Mem3 khi Login và Task List chưa được ghép vào nhánh.
class AddTaskDemoApp extends StatelessWidget {
  const AddTaskDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Task Planner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const _AddTaskDemoHome(),
    );
  }
}

class _AddTaskDemoHome extends StatefulWidget {
  const _AddTaskDemoHome();

  @override
  State<_AddTaskDemoHome> createState() => _AddTaskDemoHomeState();
}

class _AddTaskDemoHomeState extends State<_AddTaskDemoHome> {
  // MVP lưu trong RAM. Khi tích hợp, thay bằng nơi lưu task chung của nhóm.
  final List<TaskDraft> _tasks = [];

  Future<void> _openAddTask() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddTaskScreen(
          onSave: (task) async {
            _tasks.add(task);
          },
        ),
      ),
    );
    if (!mounted || saved != true) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task saved successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final latest = _tasks.isEmpty ? null : _tasks.last;
    return Scaffold(
      appBar: AppBar(title: const Text('Student Task Planner')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Add Task Demo',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tasks are saved for this session. '
                    'Restarting the app clears them.',
                  ),
                  const SizedBox(height: 24),
                  Text('Saved tasks: ${_tasks.length}'),
                  if (latest != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Last saved task'),
                            const SizedBox(height: 8),
                            Text(
                              latest.title,
                              key: const Key('last_saved_title'),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Deadline: ${MaterialLocalizations.of(context).formatMediumDate(latest.deadline)}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    key: const Key('open_add_task'),
                    onPressed: _openAddTask,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Task'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
