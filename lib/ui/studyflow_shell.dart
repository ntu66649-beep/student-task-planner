import 'package:flutter/material.dart';

import 'planner_theme.dart';

/// Shared StudyFlow workspace chrome; navigation calls the existing task flows.
class StudyFlowShell extends StatelessWidget {
  const StudyFlowShell({
    super.key,
    required this.body,
    required this.onTasks,
    required this.onPending,
    required this.onCompleted,
    required this.onLogout,
  });
  final Widget body;
  final VoidCallback onTasks;
  final VoidCallback onPending;
  final VoidCallback onCompleted;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 840;
    final logout = IconButton(
      tooltip: 'LOGOUT',
      onPressed: onLogout,
      icon: const Icon(Icons.logout_rounded),
    );
    return Scaffold(
      appBar: wide
          ? null
          : AppBar(
              toolbarHeight: 76,
              title: const Brand(onDark: true),
              actions: [logout, const SizedBox(width: 12)],
            ),
      body: Row(
        children: [
          if (wide)
            Container(
              width: 223,
              color: navy,
              padding: const EdgeInsets.fromLTRB(22, 32, 22, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Brand(onDark: true),
                  const SizedBox(height: 45),
                  const Text(
                    'KHÔNG GIAN CỦA BẠN',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.5,
                      color: Color(0xFF9298B4),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _nav(
                    Icons.grid_view_rounded,
                    'Tổng quan',
                    () {},
                    active: true,
                  ),
                  _nav(Icons.layers_outlined, 'Nhiệm vụ', onTasks),
                  _nav(Icons.schedule_rounded, 'Đang chờ', onPending),
                  _nav(Icons.task_alt_rounded, 'Đã hoàn thành', onCompleted),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF232840),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.auto_awesome_outlined,
                          color: Color(0xFFC5B6F8),
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Nhỏ thôi, nhưng đều đặn.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFD5D6E4),
                          ),
                        ),
                        SizedBox(height: 9),
                        Text(
                          'Hoàn thành một việc nhỏ cũng là một bước tiến lớn.',
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.8,
                            color: Color(0xFF9BA3C2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Column(
              children: [
                if (wide)
                  Container(
                    height: 78,
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide(color: line)),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Không gian học tập   /   Tổng quan',
                            style: TextStyle(fontSize: 12, color: muted),
                          ),
                        ),
                        Text(
                          friendlyDate(DateTime.now()),
                          style: const TextStyle(fontSize: 11, color: muted),
                        ),
                        const SizedBox(width: 16),
                        logout,
                      ],
                    ),
                  ),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _nav(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool active = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Material(
      color: active ? const Color(0xFF302C50) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          child: Row(
            children: [
              Icon(
                icon,
                size: 17,
                color: active
                    ? const Color(0xFFD3C7FF)
                    : const Color(0xFFA9AEC9),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: active
                        ? const Color(0xFFD3C7FF)
                        : const Color(0xFFA9AEC9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
