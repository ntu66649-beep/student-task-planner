import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';
import 'screens/task_list_screen.dart';
import 'ui/planner_theme.dart';

void main() => runApp(const StudentTaskPlanner());

class StudentTaskPlanner extends StatelessWidget {
  const StudentTaskPlanner({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Student Task Planner',
    theme: plannerTheme(),
    initialRoute: '/login',
    routes: {
      '/login': (_) => const LoginPage(),
      '/home': (_) => const HomePage(),
      '/tasks': (_) => const TaskListScreen(),
    },
  );
}

class MyApp extends StudentTaskPlanner {
  const MyApp({super.key});
}
