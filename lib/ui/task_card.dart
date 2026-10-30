import 'package:flutter/material.dart';

import '../models/task.dart';
import '../utils/task_validators.dart';
import 'planner_theme.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.onChanged,
    this.onDelete,
  });
  final Task task;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onDelete;
  @override
  Widget build(BuildContext context) {
    final overdue =
        !task.status &&
        dateOnly(task.deadline).isBefore(dateOnly(DateTime.now()));
    final priorityColor = switch (task.priority) {
      TaskPriority.high => const Color(0xFFB8786B),
      TaskPriority.medium => const Color(0xFFA88C4C),
      TaskPriority.low => teal,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: line),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (onChanged != null)
              Semantics(
                container: true,
                child: Checkbox(
                  key: ValueKey('checkbox-task-${task.id}'),
                  value: task.status,
                  semanticLabel: 'Toggle ${task.title}',
                  onChanged: onChanged,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  task.status
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked,
                  color: task.status ? teal : muted,
                ),
              ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w700,
                      color: task.status ? muted : ink,
                      decoration: task.status
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: muted, height: 1.5),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: priorityColor.withValues(alpha: .09),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${task.priority.label} priority',
                          style: TextStyle(
                            color: priorityColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: overdue ? orange : muted,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              '${overdue ? 'Overdue · ' : ''}${friendlyDate(task.deadline)}',
                              style: TextStyle(
                                color: overdue
                                    ? const Color(0xFFB8786B)
                                    : muted,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (task.status)
                        const Text(
                          'Completed',
                          style: TextStyle(color: teal, fontSize: 12),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                key: ValueKey('delete-task-${task.id}'),
                tooltip: 'Delete ${task.title}',
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: muted,
                  size: 21,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
