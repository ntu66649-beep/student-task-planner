import 'package:flutter/material.dart';

import 'screens/task_list_screen.dart';

void main() {
  runApp(const StudentTaskPlannerApp());
}

class StudentTaskPlannerApp extends StatelessWidget {
  const StudentTaskPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Task Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
        ),
      ),
      home: const TaskListScreen(),
    );
  }
}

// Kept as a small compatibility alias for existing imports/tests that instantiate MyApp.
class MyApp extends StudentTaskPlannerApp {
  const MyApp({super.key});
}
