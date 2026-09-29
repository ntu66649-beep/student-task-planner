import 'package:flutter/material.dart';

import 'models/task.dart';
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

      body: SafeArea(
        child: Padding(
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

              // ================= ROW 1 =================

              Row(
                children: [
                  // ================= MY TASKS =================

                  Expanded(
                    child: _buildMenuCard(
                      icon: Icons.task,
                      title: 'My Tasks',
                      subtitle: 'View your tasks',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const TaskListScreen(
                                filterStatus: null,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 15),

                  // ================= ADD TASK =================

                  Expanded(
                    child: _buildMenuCard(
                      icon: Icons.add_task,
                      title: 'Add Task',
                      subtitle: 'Create new task',
                      onTap: () async {
                        final Task? task =
                            await Navigator.of(context).push<Task>(
                          MaterialPageRoute<Task>(
                            builder: (context) {
                              return const AddTaskScreen();
                            },
                          ),
                        );

                        if (task == null) {
                          return;
                        }

                        // Lưu task vào danh sách dùng chung
                        TaskListScreen.addTask(task);

                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Task added successfully.',
                              ),
                            ),
                          );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ================= ROW 2 =================

              Row(
                children: [
                  // ================= PENDING =================

                  Expanded(
                    child: _buildMenuCard(
                      icon: Icons.pending_actions,
                      title: 'Pending',
                      subtitle: 'Tasks to do',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const TaskListScreen(
                                filterStatus: false,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 15),

                  // ================= COMPLETED =================

                  Expanded(
                    child: _buildMenuCard(
                      icon: Icons.check_circle,
                      title: 'Completed',
                      subtitle: 'Finished tasks',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const TaskListScreen(
                                filterStatus: true,
                              );
                            },
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
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  },

                  icon: const Icon(
                    Icons.logout,
                  ),

                  label: const Text(
                    'LOGOUT',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MENU CARD
  // ============================================================

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      child: InkWell(
        onTap: onTap,

        child: SizedBox(
          width: double.infinity,
          height: 170,

          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Icon(
                  icon,
                  size: 45,
                  color: Colors.blue,
                ),

                const SizedBox(height: 10),

                Text(
                  title,
                  textAlign: TextAlign.center,

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
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}