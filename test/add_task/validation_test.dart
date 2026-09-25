import 'package:flutter_test/flutter_test.dart';
import 'package:student_task_planner/features/add_task/task_draft.dart';

void main() {
  group('Title validation', () {
    test('rejects missing, empty and whitespace-only titles', () {
      for (final title in <String?>[null, '', '   ', '\n\t']) {
        expect(AddTaskValidation.title(title), isNotNull);
      }
    });

    test('accepts Vietnamese and surrounding whitespace', () {
      expect(AddTaskValidation.title('  Làm bài Lab 1  '), isNull);
    });
  });

  group('Deadline validation', () {
    final now = DateTime(2026, 9, 26, 23, 59);

    test('requires a deadline', () {
      expect(AddTaskValidation.deadline(null, now: now), isNotNull);
    });

    test('rejects yesterday and allows today without comparing time', () {
      expect(
        AddTaskValidation.deadline(DateTime(2026, 9, 25), now: now),
        isNotNull,
      );
      expect(
        AddTaskValidation.deadline(DateTime(2026, 9, 26), now: now),
        isNull,
      );
    });

    test('accepts tomorrow and a valid leap day', () {
      expect(
        AddTaskValidation.deadline(DateTime(2026, 9, 27), now: now),
        isNull,
      );
      expect(
        AddTaskValidation.deadline(DateTime(2028, 2, 29), now: now),
        isNull,
      );
    });
  });
}
