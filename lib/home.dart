import 'package:flutter/material.dart';

import 'models/task.dart';
import 'screens/task_list_screen.dart';
import 'screens/add_task_screen.dart';
import 'ui/planner_theme.dart';
import 'ui/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _openTasks([bool? status]) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => TaskListScreen(filterStatus: status),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _addTask() async {
    final task = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );
    if (task == null || !mounted) return;
    setState(() => TaskListScreen.addTask(task));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Task added successfully.')));
  }

  @override
  Widget build(BuildContext context) {
    final tasks = TaskListScreen.savedTasks;
    final completed = tasks.where((task) => task.status).length;
    final pending = tasks.length - completed;
    final upcoming = tasks.where((task) => !task.status).take(3).toList();
    final progress = tasks.isEmpty ? 0.0 : completed / tasks.length;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Brand(),
        actions: [
          IconButton(
            tooltip: 'LOGOUT',
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (_) => false,
            ),
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: PlannerContent(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
            children: [
              Row(
                children: [
                  const Expanded(child: SectionLabel('YOUR STUDENT PLANNER')),
                  Text(
                    friendlyDate(DateTime.now()),
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Make room for\nwhat matters.',
                style: TextStyle(
                  fontSize: 39,
                  height: 1.1,
                  letterSpacing: -1.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Welcome, Student! A fresh start, one task at a time.',
                style: TextStyle(color: muted, height: 1.6),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: ink,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) => Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'A LITTLE PROGRESS, EVERY DAY',
                              style: TextStyle(
                                color: Color(0xFFBFCEC4),
                                fontSize: 10,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              tasks.isEmpty
                                  ? 'Your next chapter\nstarts here.'
                                  : pending == 0
                                  ? 'All done.\nTake a well-earned break.'
                                  : '$pending tasks to go.\nYou’ve got this.',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                height: 1.2,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              onPressed: _addTask,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFECC78D),
                                foregroundColor: ink,
                              ),
                              icon: const Icon(Icons.add_rounded, size: 20),
                              label: const Text('Add Task'),
                            ),
                          ],
                        ),
                      ),
                      if (constraints.maxWidth > 280) ...[
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 84,
                          height: 84,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox.expand(
                                child: ExcludeSemantics(
                                  child: CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 6,
                                    backgroundColor: Colors.white.withValues(
                                      alpha: .12,
                                    ),
                                    color: const Color(0xFFECC78D),
                                    strokeCap: StrokeCap.round,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${(progress * 100).round()}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Text(
                                    'complete',
                                    style: TextStyle(
                                      color: Color(0xFFBFCEC4),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cards = [
                    _Stat(
                      label: 'My Tasks',
                      value: tasks.length,
                      icon: Icons.layers_outlined,
                      color: teal,
                      onTap: () => _openTasks(),
                    ),
                    _Stat(
                      label: 'Pending',
                      value: pending,
                      icon: Icons.schedule_rounded,
                      color: orange,
                      onTap: () => _openTasks(false),
                    ),
                    _Stat(
                      label: 'Completed',
                      value: completed,
                      icon: Icons.task_alt_rounded,
                      color: teal,
                      onTap: () => _openTasks(true),
                    ),
                  ];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < cards.length; i++) ...[
                        if (i > 0) const SizedBox(width: 10),
                        Expanded(child: cards[i]),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Up next',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -.5,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _openTasks(),
                    child: const Text('View all →'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (upcoming.isEmpty)
                Container(
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: line),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.wb_sunny_outlined,
                        size: 34,
                        color: orange,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        tasks.isEmpty
                            ? 'A clear space for a clear mind.'
                            : 'You’re all caught up!',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Add a study task and turn your plans into progress.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: muted, height: 1.5),
                      ),
                    ],
                  ),
                )
              else
                ...upcoming.map((task) => TaskCard(task: task)),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Small steps today. Big things tomorrow.',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: line),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 23),
            const SizedBox(height: 16),
            Text(
              '$value',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: muted)),
          ],
        ),
      ),
    ),
  );
}
