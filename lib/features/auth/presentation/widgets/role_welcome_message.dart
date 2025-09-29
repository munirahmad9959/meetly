import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';

class RoleWelcomeMessage extends StatelessWidget {
  final UserRole role;
  final String userName;

  const RoleWelcomeMessage({
    super.key,
    required this.role,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getRoleColor(role).withValues(alpha: 0.1),
            _getRoleColor(role).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getRoleColor(role).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getRoleIcon(role),
                color: _getRoleColor(role),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _getWelcomeTitle(role, userName),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _getRoleColor(role),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getWelcomeMessage(role),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _getRoleFeatures(role).map((feature) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getRoleColor(role).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  feature,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getRoleColor(role),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return const Color(0xFFFF5722);
      case UserRole.manager:
        return const Color(0xFF2196F3);
      case UserRole.hr:
        return const Color(0xFF4CAF50);
      case UserRole.salesEngineer:
        return const Color(0xFFFF9800);
      case UserRole.softwareEngineer:
        return const Color(0xFF9C27B0);
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.manager:
        return Icons.supervisor_account;
      case UserRole.hr:
        return Icons.people;
      case UserRole.salesEngineer:
        return Icons.trending_up;
      case UserRole.softwareEngineer:
        return Icons.code;
    }
  }

  String _getWelcomeTitle(UserRole role, String userName) {
    switch (role) {
      case UserRole.admin:
        return 'Welcome, Administrator $userName!';
      case UserRole.manager:
        return 'Welcome back, Manager $userName!';
      case UserRole.hr:
        return 'Hello, HR Manager $userName!';
      case UserRole.salesEngineer:
        return 'Welcome, Sales Engineer $userName!';
      case UserRole.softwareEngineer:
        return 'Hey there, Developer $userName!';
    }
  }

  String _getWelcomeMessage(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'You have full system access. Manage users, oversee all activities, and ensure smooth operations across the platform.';
      case UserRole.manager:
        return 'Lead your team effectively. Schedule meetings, track progress, and make strategic decisions for your department.';
      case UserRole.hr:
        return 'Manage employee relations, handle recruitment, and ensure a positive workplace environment for everyone.';
      case UserRole.salesEngineer:
        return 'Drive sales growth, build client relationships, and present technical solutions to potential customers.';
      case UserRole.softwareEngineer:
        return 'Build amazing features, collaborate with your team, and create solutions that make a difference.';
    }
  }

  List<String> _getRoleFeatures(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return ['User Management', 'System Settings', 'Analytics', 'Security'];
      case UserRole.manager:
        return ['Team Oversight', 'Meeting Management', 'Reports', 'Planning'];
      case UserRole.hr:
        return ['Employee Records', 'Recruitment', 'Training', 'Policies'];
      case UserRole.salesEngineer:
        return ['Client Meetings', 'Sales Pipeline', 'Proposals', 'Demos'];
      case UserRole.softwareEngineer:
        return ['Code Development', 'Bug Fixes', 'Feature Building', 'Testing'];
    }
  }
}