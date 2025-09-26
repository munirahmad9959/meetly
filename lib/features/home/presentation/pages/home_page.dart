import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../../shared/utils/notification_helper.dart';
import '../../../../shared/utils/loading_overlay.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<bool> _showLogoutDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: Colors.orange,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to sign out of your account?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meetly'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return IconButton(
                icon: const Icon(Icons.logout_rounded),
                tooltip: 'Sign Out',
                onPressed: () async {
                  // Show confirmation dialog
                  final confirmed = await _showLogoutDialog(context);
                  if (!confirmed) return;
                  
                  try {
                    // Show loading overlay
                    LoadingOverlay.show(context, message: 'Signing you out...');
                    
                    await authProvider.signOut();
                    
                    // Hide loading overlay
                    LoadingOverlay.hide();
                    
                    if (context.mounted) {
                      // Show success notification
                      NotificationHelper.showSuccess(
                        context,
                        'You have been signed out successfully 👋',
                      );
                      
                      // Navigate to login after brief delay
                      await Future.delayed(const Duration(milliseconds: 800));
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    // Hide loading overlay
                    LoadingOverlay.hide();
                    
                    if (context.mounted) {
                      // Show error notification
                      NotificationHelper.showError(
                        context,
                        'Failed to sign out. Please try again 🚫',
                      );
                    }
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Meetly!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Text(
                  'Hello ${authProvider.user?.displayName ?? authProvider.user?.email ?? 'User'}!',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Your authentication is working perfectly!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Firebase Authentication Setup Complete!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return Text(
                        'User ID: ${authProvider.user?.id}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}