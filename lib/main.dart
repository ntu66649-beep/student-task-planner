import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';

void main() {
  runApp(const StudentTaskPlanner());
}

class StudentTaskPlanner extends StatelessWidget {
  const StudentTaskPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Task Planner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/tasks': (context) => const TaskListScreen(),
      },
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Discrete Math Midterm Review',
      'subject': 'Discrete Mathematics',
      'deadline': '2026-10-02 23:59',
      'isCompleted': false,
    },
    {
      'title': 'Submit Database Project Report',
      'subject': 'Database Systems',
      'deadline': '2026-10-05 08:00',
      'isCompleted': false,
    },
    {
      'title': 'Read Chapter 4 of Database Fundamentals Book',
      'subject': 'Database Systems',
      'deadline': '2026-09-28 17:00',
      'isCompleted': true,
    },
    {
      'title': 'Read Chapter 5 of Database Fundamentals Book',
      'subject': 'Database Systems',
      'deadline': '2026-09-30 21:00',
      'isCompleted': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Student Task Planner'),
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text('No tasks available.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                final bool isCompleted = task['isCompleted'];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Checkbox(
                      value: isCompleted,
                      activeColor: Colors.blue,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _tasks[index]['isCompleted'] =
                              newValue ?? false;
                        });
                      },
                    ),
                    title: Text(
                      task['title'],
                      style: TextStyle(
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Subject: ${task['subject']}'),
                          Text(
                            'Deadline: ${task['deadline']}',
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Chip(
                      label: Text(
                        isCompleted ? 'Completed' : 'Pending',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor:
                          isCompleted ? Colors.green : Colors.orange,
                    ),
                  ),
                );
              },
            ),
    );
  }
}