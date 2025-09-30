import 'package:flutter/material.dart';
import 'package:meetly/features/auth/domain/entities/user_entity.dart';
import 'package:meetly/features/home/presentation/pages/admin_home_page.dart';
import 'package:meetly/features/home/presentation/pages/user_home_page.dart';
// import 'register_page.dart'; // Commented out - only admin can create users
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
// import '../../../home/presentation/pages/home_page.dart';
import '../../../../shared/utils/notification_helper.dart';
import '../../../../shared/utils/loading_overlay.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _getErrorMessage(String error) {
    if (error.toLowerCase().contains('user-not-found')) {
      return 'No account found with this email address 📧';
    } else if (error.toLowerCase().contains('wrong-password')) {
      return 'Incorrect password. Please try again 🔐';
    } else if (error.toLowerCase().contains('invalid-email')) {
      return 'Please enter a valid email address ✉️';
    } else if (error.toLowerCase().contains('network')) {
      return 'Network error. Check your connection 📡';
    } else if (error.toLowerCase().contains('too-many-requests')) {
      return 'Too many attempts. Please try again later ⏰';
    } else {
      return 'Login failed. Please try again 🚫';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  100,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Image.asset('assets/meetly_bg_removed.png', height: 120),
                    const SizedBox(height: 5),
                    const Text(
                      'Welcome Back,',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF55969E),
                      ),
                    ),
                    const Text(
                      "Connect and collaborate with ease",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 48),

                    // Email Field
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'E-mail',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          'assets/icons/email.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      obscureText: !_isPasswordVisible,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          'assets/icons/password.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            _isPasswordVisible
                                ? 'assets/icons/View.png'
                                : 'assets/icons/View_hide.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Login Button
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return CustomButton(
                          text: 'Login',
                          isLoading: authProvider.isLoading,
                          icon: Icons.login_rounded,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                // Show loading overlay
                                LoadingOverlay.show(
                                  context,
                                  message: 'Signing you in...',
                                );

                                await authProvider.signInWithEmailAndPassword(
                                  _emailController.text.trim(),
                                  _passwordController.text,
                                );

                                // Hide loading overlay
                                LoadingOverlay.hide();

                                if (context.mounted) {
                                  // Show success notification
                                  NotificationHelper.showSuccess(
                                    context,
                                    'Welcome back! Login successful 🎉',
                                  );

                                  // Navigate to home after a brief delay
                                  await Future.delayed(
                                    const Duration(milliseconds: 500),
                                  );
                                  if (context.mounted) {
                                    final authProvider =
                                        Provider.of<AuthProvider>(
                                          context,
                                          listen: false,
                                        );

                                    if (authProvider.isAuthenticated) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              authProvider.user?.role ==
                                                  UserRole.admin
                                              ? const AdminHomePage()
                                              : const UserHomePage(),
                                        ),
                                      );
                                    } else {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
                                        ),
                                      );
                                    }
                                  }
                                }
                              } catch (e) {
                                // Hide loading overlay
                                LoadingOverlay.hide();

                                if (context.mounted) {
                                  // Show error notification
                                  NotificationHelper.showError(
                                    context,
                                    _getErrorMessage(e.toString()),
                                  );
                                }
                              }
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Register Link - Commented out as only admin can create users
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     const Text(
                    //       "Don't have an account? ",
                    //       style: TextStyle(color: Colors.grey),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => const RegisterPage(),
                    //           ),
                    //         );
                    //       },
                    //       child: const Text(
                    //         "Register here",
                    //         style: TextStyle(
                    //           color: Colors.blue,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const Spacer(), // Push content up if extra space
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
