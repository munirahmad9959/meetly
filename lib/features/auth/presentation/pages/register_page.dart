import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../../../../shared/utils/notification_helper.dart';
import '../../../../shared/utils/loading_overlay.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _getErrorMessage(String error) {
    if (error.toLowerCase().contains('email-already-in-use')) {
      return 'An account already exists with this email 📧';
    } else if (error.toLowerCase().contains('weak-password')) {
      return 'Password is too weak. Use a stronger password 🔐';
    } else if (error.toLowerCase().contains('invalid-email')) {
      return 'Please enter a valid email address ✉️';
    } else if (error.toLowerCase().contains('network')) {
      return 'Network error. Check your connection 📡';
    } else if (error.toLowerCase().contains('operation-not-allowed')) {
      return 'Registration is currently disabled 🚫';
    } else {
      return 'Registration failed. Please try again 🚫';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Title
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                
                // Full Name Field
                CustomTextField(
                  controller: _fullNameController,
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  prefixIcon: const Icon(Icons.person),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Email Field
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
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
                  hintText: 'Enter your password',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock),
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
                const SizedBox(height: 16),
                
                // Confirm Password Field
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your password',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Register Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomButton(
                      text: 'Create Account',
                      isLoading: authProvider.isLoading,
                      icon: Icons.person_add_rounded,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            // Show loading overlay
                            LoadingOverlay.show(context, message: 'Creating your account...');
                            
                            await authProvider.registerWithEmailAndPassword(
                              _emailController.text.trim(),
                              _passwordController.text,
                              _fullNameController.text.trim(),
                            );
                            
                            // Hide loading overlay
                            LoadingOverlay.hide();
                            
                            if (context.mounted) {
                              // Show success notification
                              NotificationHelper.showSuccess(
                                context,
                                'Account created successfully! 🎉 Please login to continue.',
                              );
                              
                              // Wait a bit for user to see the notification
                              await Future.delayed(const Duration(milliseconds: 1500));
                              if (context.mounted) {
                                Navigator.pop(context); // Go back to login
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
                
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Login here',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}