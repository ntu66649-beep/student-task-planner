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
      },
    );
  }
}