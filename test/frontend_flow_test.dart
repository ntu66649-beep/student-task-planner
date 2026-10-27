import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_task_planner/main.dart';
import 'package:student_task_planner/home.dart';
import 'package:student_task_planner/models/task.dart';
import 'package:student_task_planner/screens/add_task_screen.dart';
import 'package:student_task_planner/screens/task_list_screen.dart';
import 'package:student_task_planner/ui/planner_theme.dart';

Task sample(String id, String title, {bool completed = false}) => Task(
  id: id,
  title: title,
  deadline: DateTime.now().add(const Duration(days: 2)),
  priority: TaskPriority.high,
  createdAt: DateTime.now(),
  status: completed,
);

void main() {
  setUp(() => TaskListScreen.savedTasks.clear());

  testWidgets(
    'Search and status filters work together; completion updates results',
    (tester) async {
      TaskListScreen.addTask(sample('1', 'Read chapter five'));
      TaskListScreen.addTask(sample('2', 'Submit report', completed: true));
      await tester.pumpWidget(
        MaterialApp(theme: plannerTheme(), home: const TaskListScreen()),
      );
      await tester.enterText(
        find.byKey(const ValueKey('taskSearchField')),
        'chapter',
      );
      await tester.pumpAndSettle();
      expect(find.text('Read chapter five'), findsOneWidget);
      expect(find.text('Submit report'), findsNothing);
      await tester.tap(find.widgetWithText(ChoiceChip, 'Completed'));
      await tester.pumpAndSettle();
      expect(find.text('No matching tasks'), findsOneWidget);
      await tester.tap(find.byTooltip('Clear search'));
      await tester.pumpAndSettle();
      expect(find.text('Submit report'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('checkbox-task-2')));
      await tester.pumpAndSettle();
      expect(TaskListScreen.savedTasks.last.status, isFalse);
      expect(find.text('Submit report'), findsNothing);
    },
  );

  testWidgets('Delete requires confirmation and cancel keeps the task', (
    tester,
  ) async {
    TaskListScreen.addTask(sample('1', 'Keep my assignment'));
    await tester.pumpWidget(
      MaterialApp(theme: plannerTheme(), home: const TaskListScreen()),
    );
    await tester.tap(find.byKey(const ValueKey('delete-task-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('btn_cancel_delete')));
    await tester.pumpAndSettle();
    expect(TaskListScreen.savedTasks, hasLength(1));
    await tester.tap(find.byKey(const ValueKey('delete-task-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('btn_confirm_delete')));
    await tester.pumpAndSettle();
    expect(TaskListScreen.savedTasks, isEmpty);
    expect(find.text('No tasks yet'), findsOneWidget);
  });

  testWidgets(
    'Login, task change, dashboard refresh and logout stay connected',
    (tester) async {
      TaskListScreen.addTask(sample('1', 'Finish testing'));
      await tester.pumpWidget(const StudentTaskPlanner());
      await tester.enterText(
        find.byKey(const ValueKey('usernameField')),
        'student',
      );
      await tester.enterText(
        find.byKey(const ValueKey('passwordField')),
        '123456',
      );
      await tester.ensureVisible(find.byKey(const ValueKey('loginButton')));
      await tester.tap(find.byKey(const ValueKey('loginButton')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('My Tasks'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('My Tasks'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const ValueKey('checkbox-task-1')));
      await tester.tap(find.byKey(const ValueKey('checkbox-task-1')));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('All done.\nTake a well-earned break.'), findsOneWidget);
      await tester.tap(find.byTooltip('LOGOUT'));
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsOneWidget);
    },
  );

  for (final size in [
    const Size(320, 640),
    const Size(390, 844),
    const Size(1280, 900),
  ]) {
    testWidgets('Screens fit at ${size.width} with large text', (tester) async {
      TaskListScreen.addTask(
        sample(
          'responsive',
          'Prepare the final software testing presentation and review all scenarios',
        ),
      );
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final page in [
        const HomePage(),
        const TaskListScreen(),
        const AddTaskScreen(),
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: plannerTheme(),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(1.3)),
              child: child!,
            ),
            home: page,
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: 'Screen: ${page.runtimeType}',
        );
      }
      await tester.pumpWidget(const StudentTaskPlanner());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
