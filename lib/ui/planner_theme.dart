import 'package:flutter/material.dart';

const navy = Color(0xFF191D33);
const soft = Color(0xFFF0ECFC);

const ink = Color(0xFF2B2D43);
const muted = Color(0xFF78788D);
const paper = Color(0xFFF7F8FC);
const teal = Color(0xFF7662CF);
const line = Color(0xFFE9E8F0);
const orange = Color(0xFFAC7D42);

ThemeData plannerTheme() {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: line),
  );
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Segoe UI',
    fontFamilyFallback: const ['Roboto', 'Arial'],
    colorScheme: ColorScheme.fromSeed(
      seedColor: teal,
      surface: Colors.white,
    ).copyWith(primary: teal, onPrimary: Colors.white, outline: line),
    scaffoldBackgroundColor: paper,
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: 'Segoe UI',
      bodyColor: ink,
      displayColor: ink,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: navy,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: teal, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      hintStyle: const TextStyle(color: muted, fontSize: 14),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: teal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        side: const BorderSide(color: line),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: teal,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: ink,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dividerTheme: const DividerThemeData(color: line),
  );
}

class PlannerContent extends StatelessWidget {
  const PlannerContent({super.key, required this.child, this.width = 1000});
  final Widget child;
  final double width;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: child,
    ),
  );
}

class Brand extends StatelessWidget {
  const Brand({super.key, this.onDark = false});
  final bool onDark;
  @override
  Widget build(BuildContext context) => FittedBox(
    fit: BoxFit.scaleDown,
    alignment: Alignment.centerLeft,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: teal,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.layers_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 11),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Study',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(
                    text: 'Flow',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              style: TextStyle(
                fontSize: 23,
                letterSpacing: -.7,
                color: onDark ? Colors.white : ink,
              ),
            ),
            const Text(
              'STUDENT WORKSPACE',
              style: TextStyle(
                fontSize: 8,
                letterSpacing: 2,
                color: Color(0xFF969BB6),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 11,
      letterSpacing: 2,
      fontWeight: FontWeight.w700,
      color: muted,
    ),
  );
}

String friendlyDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
