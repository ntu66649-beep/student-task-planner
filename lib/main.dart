import 'package:flutter/material.dart';

import 'login.dart';
import 'home.dart';
import 'screens/task_list_screen.dart';

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
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
        ),
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

// Giữ alias này để các test cũ của Member 3
// nếu gọi MyApp() vẫn có thể hoạt động.
class MyApp extends StudentTaskPlanner {
  const MyApp({super.key});
}