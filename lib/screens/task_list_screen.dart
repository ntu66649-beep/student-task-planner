import 'package:flutter/material.dart';

import '../data/task_store.dart';
import '../models/task.dart';
import '../ui/planner_theme.dart';
import '../ui/task_card.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key, this.filterStatus});
  final bool? filterStatus;
  static List<Task> get savedTasks => TaskStore.tasks;
  static void addTask(Task task) => TaskStore.addTask(task);
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _search = TextEditingController();
  bool? _status;
  @override
  void initState() {
    super.initState();
    _status = widget.filterStatus;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Task> get _displayTasks => TaskListScreen.savedTasks
      .where(
        (task) =>
            (_status == null || task.status == _status) &&
            ('${task.title} ${task.description}'.toLowerCase().contains(
              _search.text.trim().toLowerCase(),
            )),
      )
      .toList();
  Future<void> _openAddTask() async {
    final task = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );
    if (task == null || !mounted) return;
    setState(() => TaskListScreen.addTask(task));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Task added successfully.')));
  }

  Future<void> _delete(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.delete_outline_rounded, color: orange),
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete task "${task.title}"?'),
        actions: [
          TextButton(
            key: const ValueKey('btn_cancel_delete'),
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const ValueKey('btn_confirm_delete'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB45A58),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => TaskStore.deleteTask(task.id));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Task deleted successfully.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _displayTasks;
    final all = TaskListScreen.savedTasks;
    final completed = all.where((task) => task.status).length;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: PlannerContent(
          child: CustomScrollView(
            key: const ValueKey('taskList'),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionLabel('LESS OVERWHELM. MORE MOMENTUM.'),
                      const SizedBox(height: 12),
                      const Text(
                        'Your plans,\nin one place.',
                        style: TextStyle(
                          fontSize: 35,
                          height: 1.1,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${all.length - completed} pending · $completed completed',
                        style: const TextStyle(color: muted),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        key: const ValueKey('taskSearchField'),
                        controller: _search,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search your tasks',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _search.text.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Clear search',
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () =>
                                      setState(() => _search.clear()),
                                ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final entry in <(String, bool?)>[
                              ('All', null),
                              ('Pending', false),
                              ('Completed', true),
                            ])
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(entry.$1),
                                  selected: _status == entry.$2,
                                  showCheckmark: false,
                                  selectedColor: teal,
                                  backgroundColor: Colors.white,
                                  labelStyle: TextStyle(
                                    color: _status == entry.$2
                                        ? Colors.white
                                        : muted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  side: BorderSide(
                                    color: _status == entry.$2 ? teal : line,
                                  ),
                                  onSelected: (_) =>
                                      setState(() => _status = entry.$2),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${tasks.length} ${tasks.length == 1 ? 'task' : 'tasks'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.sort_rounded,
                            size: 16,
                            color: muted,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Deadline first',
                            style: TextStyle(fontSize: 12, color: muted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (tasks.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 20, 28, 110),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF0ECFC),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.checklist_rounded,
                            size: 40,
                            color: teal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _search.text.isNotEmpty
                              ? 'No matching tasks'
                              : _status == null
                              ? 'No tasks yet'
                              : _status == true
                              ? 'No completed tasks yet'
                              : 'Nothing left to do',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _search.text.isNotEmpty
                              ? 'Try a different title or clear your search.'
                              : _status == true
                              ? 'Your finished tasks will appear here.'
                              : 'Tap “Add Task” to create your first study task.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: muted, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 110),
                  sliver: SliverList.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskCard(
                        key: ValueKey('task-${task.id}'),
                        task: task,
                        onChanged: (value) => setState(
                          () => TaskStore.updateTask(
                            task.copyWith(status: value ?? false),
                          ),
                        ),
                        onDelete: () => _delete(task),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('addTaskButton'),
        tooltip: 'Add Task',
        onPressed: _openAddTask,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Task'),
      ),
    );
  }
}
