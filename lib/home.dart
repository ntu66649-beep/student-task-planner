import 'package:flutter/material.dart';

import 'screens/task_list_screen.dart';
import 'screens/add_task_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Task Planner'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ================= WELCOME =================

            const Text(
              'Welcome, Student!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Manage your tasks and deadlines',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // ================= MENU ROW 1 =================

            Row(
              children: [
                // 1. MY TASKS
                Expanded(
                  child: _buildMenuCard(
                    icon: Icons.task,
                    title: 'My Tasks',
                    subtitle: 'View your tasks',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TaskListScreen(filterStatus: null),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 15),

                // 2. ADD TASK
                Expanded(
                  child: _buildMenuCard(
                    icon: Icons.add_task,
                    title: 'Add Task',
                    subtitle: 'Create new task',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTaskScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ================= MENU ROW 2 =================

            Row(
              children: [
                // 3. PENDING
                Expanded(
                  child: _buildMenuCard(
                    icon: Icons.pending_actions,
                    title: 'Pending',
                    subtitle: 'Tasks to do',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TaskListScreen(filterStatus: false),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 15),

                // 4. COMPLETED
                Expanded(
                  child: _buildMenuCard(
                    icon: Icons.check_circle,
                    title: 'Completed',
                    subtitle: 'Finished tasks',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TaskListScreen(filterStatus: true),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const Spacer(),

            // ================= LOGOUT =================

            SizedBox(
              width: double.infinity,
              height: 50,

              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/login',
                  );
                },

                icon: const Icon(Icons.logout),

                label: const Text('LOGOUT'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 3,

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              Icon(
                icon,
                size: 45,
                color: Colors.blue,
              ),

              const SizedBox(height: 10),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}