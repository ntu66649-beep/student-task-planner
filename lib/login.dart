import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  bool isPasswordHidden = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username == 'student' && password == '123456') {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid username or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ================= LOGO =================

                  Center(
                    child: Container(
                      width: 80,
                      height: 80,

                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Icon(
                        Icons.task_alt,
                        color: Colors.white,
                        size: 45,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ================= APP NAME =================

                  const Center(
                    child: Text(
                      'Student Task Planner',

                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Center(
                    child: Text(
                      'Manage your tasks and deadlines',

                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ================= LOGIN =================

                  const Text(
                    'Login',

                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= USERNAME =================

                  const Text(
                    'Username or Email',

                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: usernameController,

                    keyboardType: TextInputType.emailAddress,

                    decoration: InputDecoration(
                      hintText: 'Enter username or email',

                      prefixIcon: const Icon(
                        Icons.person_outline,
                      ),

                      filled: true,
                      fillColor: Colors.white,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter username or email';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // ================= PASSWORD =================

                  const Text(
                    'Password',

                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: passwordController,

                    obscureText: isPasswordHidden,

                    decoration: InputDecoration(
                      hintText: 'Enter password',

                      prefixIcon: const Icon(
                        Icons.lock_outline,
                      ),

                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),

                        onPressed: () {
                          setState(() {
                            isPasswordHidden =
                            !isPasswordHidden;
                          });
                        },
                      ),

                      filled: true,
                      fillColor: Colors.white,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
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

                  // ================= FORGOT PASSWORD =================

                  Align(
                    alignment: Alignment.centerRight,

                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Forgot password feature',
                            ),
                          ),
                        );
                      },

                      child: const Text(
                        'Forgot Password?',
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ================= LOGIN BUTTON =================

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed: login,

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFF2563EB),

                        foregroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),

                      child: const Text(
                        'LOGIN',

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= DEMO ACCOUNT =================

                  const Center(
                    child: Text(
                      'Demo account: student / 123456',

                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
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
}