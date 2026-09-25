import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_task_planner/features/add_task/add_task_screen.dart';
import 'package:student_task_planner/features/add_task/task_draft.dart';
import 'package:student_task_planner/main_add_task.dart';

Future<void> openForm(
  WidgetTester tester,
  Future<void> Function(TaskDraft) save,
) async {
  await tester.pumpWidget(MaterialApp(
    home: Builder(
      builder: (context) => Scaffold(
        body: TextButton(
          onPressed: () => Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => AddTaskScreen(onSave: save),
            ),
          ),
          child: const Text('Open form'),
        ),
      ),
    ),
  ));
  await tester.tap(find.text('Open form'));
  await tester.pumpAndSettle();
}

Future<void> fillValidForm(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const Key('add_task_title')),
    '  Làm bài Lab 1  ',
  );
  await tester.tap(find.byKey(const Key('add_task_deadline')));
  await tester.pumpAndSettle();
  final labels = MaterialLocalizations.of(tester.element(find.byType(DatePickerDialog)));
  await tester.tap(find.text(labels.okButtonLabel));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('empty submission shows both errors without saving', (tester) async {
    var calls = 0;
    await openForm(tester, (_) async { calls++; });
    await tester.tap(find.byKey(const Key('add_task_save')));
    await tester.pump();
    expect(find.text('Please enter a task title.'), findsOneWidget);
    expect(find.text('Please select a deadline.'), findsOneWidget);
    expect(calls, 0);
  });

  testWidgets('valid submission saves trimmed data and closes form', (tester) async {
    TaskDraft? saved;
    await openForm(tester, (task) async { saved = task; });
    await fillValidForm(tester);
    final expectedDate = AddTaskValidation.dateOnly(DateTime.now());
    await tester.tap(find.byKey(const Key('add_task_save')));
    await tester.pumpAndSettle();
    expect(saved!.title, 'Làm bài Lab 1');
    expect(saved!.deadline, expectedDate);
    expect(find.byType(AddTaskScreen), findsNothing);
  });

  testWidgets('rapid Save taps call storage only once', (tester) async {
    var calls = 0;
    final completion = Completer<void>();
    await openForm(tester, (_) {
      calls++;
      return completion.future;
    });
    await fillValidForm(tester);
    final button = find.byKey(const Key('add_task_save'));
    await tester.tap(button);
    await tester.tap(button);
    await tester.pump();
    expect(calls, 1);
    expect(tester.widget<FilledButton>(button).onPressed, isNull);
    expect(find.text('Saving...'), findsOneWidget);
    // Không cho rời màn hình bằng Back trong lúc đang lưu.
    final navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
    await navigator.maybePop();
    await tester.pump();
    expect(find.byType(AddTaskScreen), findsOneWidget);
    completion.complete();
    await tester.pumpAndSettle();
    expect(find.byType(AddTaskScreen), findsNothing);
  });

  testWidgets('failed save preserves input and allows retry', (tester) async {
    var calls = 0;
    await openForm(tester, (_) async {
      calls++;
      if (calls == 1) throw StateError('Storage unavailable');
    });
    await fillValidForm(tester);
    await tester.tap(find.byKey(const Key('add_task_save')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('add_task_save_error')), findsOneWidget);
    expect(find.text('  Làm bài Lab 1  '), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('add_task_save')));
    await tester.tap(find.byKey(const Key('add_task_save')));
    await tester.pumpAndSettle();
    expect(calls, 2);
    expect(find.byType(AddTaskScreen), findsNothing);
  });

  testWidgets('Cancel does not save', (tester) async {
    var calls = 0;
    await openForm(tester, (_) async { calls++; });
    await fillValidForm(tester);
    await tester.tap(find.byKey(const Key('add_task_cancel')));
    await tester.pumpAndSettle();
    expect(calls, 0);
    expect(find.byType(AddTaskScreen), findsNothing);
  });

  testWidgets('cancelling date picker leaves deadline required', (tester) async {
    await openForm(tester, (_) async {});
    await tester.tap(find.byKey(const Key('add_task_deadline')));
    await tester.pumpAndSettle();
    final labels = MaterialLocalizations.of(tester.element(find.byType(DatePickerDialog)));
    await tester.tap(find.text(labels.cancelButtonLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('add_task_save')));
    await tester.pump();
    expect(find.text('Please select a deadline.'), findsOneWidget);
  });

  testWidgets('demo retains multiple tasks across form visits', (tester) async {
    await tester.pumpWidget(const AddTaskDemoApp());
    for (var count = 1; count <= 2; count++) {
      await tester.tap(find.byKey(const Key('open_add_task')));
      await tester.pumpAndSettle();
      await fillValidForm(tester);
      await tester.tap(find.byKey(const Key('add_task_save')));
      await tester.pumpAndSettle();
      expect(find.text('Saved tasks: $count'), findsOneWidget);
      expect(find.text('Làm bài Lab 1'), findsOneWidget);
    }
  });
}
