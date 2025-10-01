import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/home/presentation/pages/admin_home_page.dart';
import '../../features/home/presentation/pages/user_home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/domain/entities/user_entity.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading screen while checking authentication
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Navigate based on authentication status
        if (authProvider.isAuthenticated) {
          final role = authProvider.user?.role ?? UserRole.softwareEngineer;
          if (role == UserRole.admin) {
            return const AdminHomePage();
          }
          return const UserHomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}