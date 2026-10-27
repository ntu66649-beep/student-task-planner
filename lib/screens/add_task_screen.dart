import 'package:flutter/material.dart';

import '../models/task.dart';
import '../ui/planner_theme.dart';
import '../utils/task_validators.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  static const int _maximumTitleLength = 100;
  static const int _maximumDescriptionLength = 500;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController = TextEditingController();

  DateTime? _deadline;
  TaskPriority _priority = TaskPriority.medium;
  bool _isSaving = false;
  bool _hasAttemptedSave = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _pickDeadline() async {
    FocusScope.of(context).unfocus();

    final now = DateTime.now();
    final today = dateOnly(now);
    final selected = await showDatePicker(
      context: context,
      initialDate: _deadline ?? today,
      firstDate: today,
      lastDate: DateTime(today.year + 10, today.month, today.day),
      helpText: 'Select deadline',
      cancelText: 'Cancel',
      confirmText: 'OK',
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _deadline = dateOnly(selected);
      _deadlineController.text = _formatDate(selected);
    });

    // Revalidate only after the user has already attempted to save.
    if (_hasAttemptedSave && _formKey.currentState != null) {
      _formKey.currentState!.validate();
    }
  }

  Future<void> _saveTask() async {
    // A second rapid tap can invoke the old callback before the disabled button
    // is rebuilt, so guard at the handler level as well.
    if (_isSaving) {
      return;
    }

    FocusScope.of(context).unfocus();
    _hasAttemptedSave = true;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final deadline = _deadline;
    if (deadline == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final now = DateTime.now();
    final task = Task(
      id: now.microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      deadline: deadline,
      priority: _priority,
      createdAt: now,
    );

    // Yield one frame so the button becomes disabled before returning.
    await Future<void>.delayed(Duration.zero);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(task);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Add Task')),
    body: SafeArea(
      child: PlannerContent(
        width: 680,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel('MAKE YOUR NEXT MOVE'),
                const SizedBox(height: 12),
                const Text(
                  'Small task. Big step.',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Give your goal a name and a little space in your day.',
                  style: TextStyle(color: muted, height: 1.5),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  key: const ValueKey('taskTitleField'),
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  maxLength: _maximumTitleLength,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    hintText: 'e.g. Submit testing assignment',
                  ),
                  validator: validateTaskTitle,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const ValueKey('taskDescriptionField'),
                  controller: _descriptionController,
                  textInputAction: TextInputAction.newline,
                  minLines: 3,
                  maxLines: 5,
                  maxLength: _maximumDescriptionLength,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Optional notes',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const ValueKey('taskDeadlineField'),
                  controller: _deadlineController,
                  readOnly: true,
                  onTap: _pickDeadline,
                  decoration: InputDecoration(
                    labelText: 'Deadline *',
                    hintText: 'DD/MM/YYYY',
                    suffixIcon: IconButton(
                      key: const ValueKey('openDeadlinePickerButton'),
                      tooltip: 'Select deadline',
                      onPressed: _pickDeadline,
                      icon: const Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                  validator: (_) =>
                      validateTaskDeadline(_deadline, DateTime.now()),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<TaskPriority>(
                  key: const ValueKey('taskPriorityDropdown'),
                  initialValue: _priority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    prefixIcon: Icon(Icons.flag_outlined),
                  ),
                  items: TaskPriority.values
                      .map(
                        (priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority.label),
                        ),
                      )
                      .toList(),
                  onChanged: _isSaving
                      ? null
                      : (priority) {
                          if (priority != null) {
                            setState(() => _priority = priority);
                          }
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    bottomNavigationBar: SafeArea(
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: Row(
              children: [
                TextButton(
                  key: const ValueKey('cancelAddTaskButton'),
                  onPressed: _isSaving ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    key: const ValueKey('saveTaskButton'),
                    onPressed: _isSaving ? null : _saveTask,
                    child: Text(_isSaving ? 'Saving...' : 'Save Task'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
