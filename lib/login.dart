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
          backgroundColor: Color(0xFFAB423B),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 840;
          final form = Padding(
            padding: EdgeInsets.all(wide ? 48 : 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Brand(),
                const SizedBox(height: 40),
                const SectionLabel('YOUR SPACE TO MAKE PROGRESS'),
                const SizedBox(height: 14),
                const Text(
                  'A little focus.\nA lot of possibility.',
                  style: TextStyle(
                    fontSize: 36,
                    height: 1.12,
                    letterSpacing: -1.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Student Task Planner',
                  style: TextStyle(color: muted, fontSize: 15),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Welcome back. Let’s plan a good day.',
                  style: TextStyle(color: muted),
                ),
                const SizedBox(height: 24),
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
                            prefixIcon: Icon(Icons.person_outline_rounded),
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
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
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
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            key: const ValueKey('loginButton'),
                            onPressed: login,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('LOGIN'),
                                SizedBox(width: 12),
                                Icon(Icons.arrow_forward_rounded, size: 19),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EDE3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline_rounded,
                        size: 20,
                        color: teal,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Demo account: student / 123456',
                          style: TextStyle(fontSize: 12, color: ink),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
          return Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: wide
                    ? Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Container(
                                constraints: const BoxConstraints(
                                  minHeight: 700,
                                ),
                                padding: const EdgeInsets.all(42),
                                decoration: BoxDecoration(
                                  color: ink,
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'LESS CHAOS. MORE CLARITY.',
                                      style: TextStyle(
                                        color: Color(0xFFC3D8CD),
                                        fontSize: 11,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 50),
                                    const Icon(
                                      Icons.auto_awesome_rounded,
                                      size: 62,
                                      color: Color(0xFFECC78D),
                                    ),
                                    const SizedBox(height: 30),
                                    const Text(
                                      'Big goals.\nSmall steps.\nYour pace.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 51,
                                        height: 1.05,
                                        letterSpacing: -2,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    const Text(
                                      'A calmer place for assignments, deadlines,\nand everything you’re working toward.',
                                      style: TextStyle(
                                        color: Color(0xFFC3D8CD),
                                        height: 1.8,
                                      ),
                                    ),
                                    const SizedBox(height: 50),
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: .08,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle_rounded,
                                            color: Color(0xFFECC78D),
                                          ),
                                          SizedBox(width: 14),
                                          Expanded(
                                            child: Text(
                                              'One task at a time. You’ve got this.',
                                              style: TextStyle(
                                                color: Colors.white,
                                                height: 1.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: form),
                        ],
                      )
                    : form,
              ),
            ),
          );
        },
      ),
    ),
  );
}
