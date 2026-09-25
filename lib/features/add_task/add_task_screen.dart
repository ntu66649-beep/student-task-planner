import 'package:flutter/material.dart';

import 'task_draft.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, required this.onSave});

  // Nơi gọi màn hình cung cấp hàm lưu: bộ nhớ, database hoặc API.
  // Chỉ hoàn thành Future khi lưu thành công; throw khi lưu thất bại.
  final Future<void> Function(TaskDraft task) onSave;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _deadlineController = TextEditingController();
  DateTime? _deadline;
  bool _saving = false;
  bool _pickingDate = false;
  String? _saveError;

  @override
  void dispose() {
    _titleController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    if (_saving || _pickingDate) return;
    _pickingDate = true;
    final today = AddTaskValidation.dateOnly(DateTime.now());
    final selected = _deadline;
    try {
      final picked = await showDatePicker(
        context: context,
        initialDate: selected == null || selected.isBefore(today)
            ? today
            : selected,
        firstDate: today,
        // Giới hạn của giao diện lịch; không phải yêu cầu của đề bài.
        lastDate: DateTime(today.year + 100, 12, 31),
        helpText: 'Select deadline',
        fieldLabelText: 'Deadline',
      );
      if (!mounted || picked == null) return;
      setState(() {
        _deadline = AddTaskValidation.dateOnly(picked);
        _deadlineController.text =
            MaterialLocalizations.of(context).formatMediumDate(picked);
      });
    } finally {
      _pickingDate = false;
    }
  }

  Future<void> _save() async {
    // Chặn cả hai lần nhấn liên tiếp trước khi nút kịp vẽ lại.
    if (_saving || _pickingDate) return;
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final task = TaskDraft(
      title: _titleController.text.trim(),
      deadline: _deadline!,
    );
    setState(() {
      _saving = true;
      _saveError = null;
    });
    try {
      await widget.onSave(task);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _saveError = 'Could not save the task. Please try again.';
      });
      return;
    }
    if (!mounted) return;
    // Trả true cho màn hình trước để cập nhật danh sách / thông báo.
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Task')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Plan your next task',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      const Text('Enter a title and choose a deadline.'),
                      const SizedBox(height: 24),
                      TextFormField(
                        key: const Key('add_task_title'),
                        controller: _titleController,
                        enabled: !_saving,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          hintText: 'Example: Finish Lab 1',
                          border: OutlineInputBorder(),
                        ),
                        validator: AddTaskValidation.title,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        key: const Key('add_task_deadline'),
                        controller: _deadlineController,
                        enabled: !_saving,
                        readOnly: true,
                        onTap: _pickDeadline,
                        decoration: const InputDecoration(
                          labelText: 'Deadline',
                          hintText: 'Select a date',
                          helperText: 'Today or a future date',
                          suffixIcon: Icon(Icons.calendar_today_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (_) =>
                            AddTaskValidation.deadline(_deadline),
                      ),
                      if (_saveError != null) ...[
                        const SizedBox(height: 16),
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            _saveError!,
                            key: const Key('add_task_save_error'),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 28),
                      FilledButton(
                        key: const Key('add_task_save'),
                        onPressed: _saving ? null : _save,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: _saving
                              ? const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Saving...'),
                                  ],
                                )
                              : const Text('Save task'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        key: const Key('add_task_cancel'),
                        onPressed: _saving
                            ? null
                            : () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
