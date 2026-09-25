import 'package:flutter_test/flutter_test.dart';
import 'package:student_task_planner/main.dart';

void main() {
  testWidgets('Login page displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentTaskPlanner());

    expect(find.text('Student Task Planner'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Username or Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}