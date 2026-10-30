import 'package:flutter/material.dart';

import 'ui/planner_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordHidden = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (!_formKey.currentState!.validate()) return;
    if (usernameController.text.trim() == 'student' &&
        passwordController.text.trim() == '123456') {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid username or password'),
          backgroundColor: Color(0xFFB45A58),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 840;
          final story = Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: wide ? constraints.maxHeight : 0,
            ),
            color: navy,
            padding: EdgeInsets.all(wide ? 52 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Brand(onDark: true),
                SizedBox(height: wide ? 80 : 32),
                const Text(
                  'ÍT ÁP LỰC HƠN. NHIỀU TIẾN BỘ HƠN.',
                  style: TextStyle(
                    color: Color(0xFFACA3D5),
                    fontSize: 10,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 22),
                Text.rich(
                  const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Mỗi ngày một chút.\n',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: 'Tiến xa hơn.',
                        style: TextStyle(color: Color(0xFFB9A9F2)),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: wide ? 44 : 34,
                    height: 1.35,
                    letterSpacing: -1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Gom bài tập, sắp xếp ưu tiên và dành thời gian cho điều quan trọng. Một không gian cho mọi kế hoạch học tập.',
                  style: TextStyle(
                    color: Color(0xFFA2A6BF),
                    fontSize: 14,
                    height: 1.9,
                  ),
                ),
                if (wide) ...[
                  const SizedBox(height: 45),
                  Transform.rotate(
                    angle: -.06,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2E48),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Color(0xFFC1E8DB),
                            child: Icon(
                              Icons.check_rounded,
                              color: Color(0xFF3B7A66),
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hoàn thành bài thực hành',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'Thêm một bước tiến hôm nay',
                                  style: TextStyle(
                                    color: Color(0xFFA2A8C2),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: soft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tiến độ học tập',
                          style: TextStyle(fontSize: 11, color: muted),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Vững bước mỗi ngày',
                          style: TextStyle(
                            fontSize: 17,
                            color: ink,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20),
                        LinearProgressIndicator(
                          value: .7,
                          color: teal,
                          backgroundColor: Color(0xFFDED7EE),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  const Text(
                    'Sắp xếp hôm nay. Tự tin ngày mai.',
                    style: TextStyle(color: Color(0xFF9198B9), fontSize: 11),
                  ),
                ],
              ],
            ),
          );
          final form = Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: wide ? 40 : 24,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SectionLabel('KHÔNG GIAN HỌC TẬP CỦA BẠN'),
                    const SizedBox(height: 9),
                    const Text(
                      'Chào mừng trở lại.',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -.8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Student Task Planner',
                      style: TextStyle(color: muted, fontSize: 13),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: Column(
                          children: [
                            TextFormField(
                              key: const ValueKey('usernameField'),
                              controller: usernameController,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.username],
                              decoration: const InputDecoration(
                                labelText: 'Username or Email',
                                hintText: 'Enter username or email',
                              ),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Please enter username or email'
                                  : null,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              key: const ValueKey('passwordField'),
                              controller: passwordController,
                              obscureText: isPasswordHidden,
                              autofillHints: const [AutofillHints.password],
                              onFieldSubmitted: (_) => login(),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter password',
                                suffixIcon: IconButton(
                                  tooltip: isPasswordHidden
                                      ? 'Show password'
                                      : 'Hide password',
                                  icon: Icon(
                                    isPasswordHidden
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  onPressed: () => setState(
                                    () => isPasswordHidden = !isPasswordHidden,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => showDialog<void>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Demo account'),
                                    content: const Text(
                                      'Use student / 123456 to try the planner. Password recovery is not available for this demo.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Got it'),
                                      ),
                                    ],
                                  ),
                                ),
                                child: const Text('Forgot Password?'),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                key: const ValueKey('loginButton'),
                                onPressed: login,
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('LOGIN'),
                                    Icon(Icons.arrow_forward_rounded, size: 19),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 22),
                    const SectionLabel('KHÁM PHÁ VỚI TÀI KHOẢN DEMO'),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          usernameController.text = 'student';
                          passwordController.text = '123456';
                        },
                        icon: const Icon(Icons.person_outline),
                        label: const Text('student / 123456'),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Bản demo • Dữ liệu được giữ trong phiên ứng dụng.',
                      style: TextStyle(color: muted, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          );
          return SingleChildScrollView(
            child: wide
                ? IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: story),
                        Expanded(child: form),
                      ],
                    ),
                  )
                : Column(children: [story, form]),
          );
        },
      ),
    ),
  );
}
