import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:student_task_planner/main.dart';
import 'package:student_task_planner/utils/task_validators.dart';

void main() {
  Future<void> openAddTaskScreen(WidgetTester tester) async {
    await tester.pumpWidget(const StudentTaskPlannerApp());
    await tester.tap(find.byKey(const ValueKey('addTaskButton')));
    await tester.pumpAndSettle();
  }

  testWidgets('TC01 - Add a valid task and show it in task list', (
    WidgetTester tester,
  ) async {
    await openAddTaskScreen(tester);

    await tester.enterText(
      find.byKey(const ValueKey('taskTitleField')),
      'Submit SWT301 assignment',
    );

    await tester.tap(find.byKey(const ValueKey('taskDeadlineField')));
    await tester.pumpAndSettle();

    // The date picker opens on today, which is a valid (not past) deadline.
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('saveTaskButton')));
    await tester.pumpAndSettle();

    expect(find.text('Submit SWT301 assignment'), findsOneWidget);
    expect(find.text('Task added successfully.'), findsOneWidget);
  });

  testWidgets('TC02 - Empty title is rejected', (WidgetTester tester) async {
    await openAddTaskScreen(tester);

    await tester.tap(find.byKey(const ValueKey('taskDeadlineField')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('saveTaskButton')));
    await tester.pump();

    expect(find.text('Title is required.'), findsOneWidget);
    expect(find.text('Add Task'), findsOneWidget);
  });

  testWidgets('TC03 - Empty deadline is rejected', (WidgetTester tester) async {
    await openAddTaskScreen(tester);

    await tester.enterText(
      find.byKey(const ValueKey('taskTitleField')),
      'Read chapter 5',
    );
    await tester.tap(find.byKey(const ValueKey('saveTaskButton')));
    await tester.pump();

    expect(find.text('Deadline is required.'), findsOneWidget);
  });

  test('TC04 - Past deadline is rejected by validator', () {
    final now = DateTime(2026, 9, 26, 15);
    final yesterday = DateTime(2026, 9, 25, 23, 59);

    expect(
      validateTaskDeadline(yesterday, now),
      'Deadline cannot be in the past.',
    );
  });

  test('Deadline on the current day is valid', () {
    final now = DateTime(2026, 9, 26, 15);
    final todayMorning = DateTime(2026, 9, 26, 8);

    expect(validateTaskDeadline(todayMorning, now), isNull);
  });

  testWidgets('TC05 - Rapid Save taps do not add duplicate tasks', (
    WidgetTester tester,
  ) async {
    await openAddTaskScreen(tester);

    await tester.enterText(
      find.byKey(const ValueKey('taskTitleField')),
      'One task only',
    );

    await tester.tap(find.byKey(const ValueKey('taskDeadlineField')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    final saveButton = find.byKey(const ValueKey('saveTaskButton'));

    // Invoke two taps without pumping a rebuilt button between them.
    await tester.tap(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('One task only'), findsOneWidget);
  });
}
