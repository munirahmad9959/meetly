import 'package:flutter/material.dart';
import 'package:meetly/shared/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/role_badge.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.brandBlack,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppTheme.brandBg,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: AppTheme.brandBg),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Profile Card
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                final user = authProvider.user;
                if (user == null) return const SizedBox.shrink();
                
                return Container(
                  decoration: BoxDecoration(
                    color: AppTheme.brandBg,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: AppTheme.brandBg,
                            backgroundImage: user.photoUrl != null
                                ? NetworkImage(user.photoUrl!)
                                : null,
                            child: user.photoUrl == null
                                ? RoleIcon(role: user.role, size: 32)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.fullName ?? 'No Name',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.brandBlack,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.brandBlack.withValues(alpha: 0.7),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                RoleBadge(role: user.role),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.brandBullet,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              user.emailVerified ? Icons.verified : Icons.warning_amber_rounded,
                              color: user.emailVerified
                                  ? AppTheme.brandGreen
                                  : AppTheme.brandDanger,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              user.emailVerified
                                  ? 'Email Verified'
                                  : 'Email Not Verified',
                              style: TextStyle(
                                color: user.emailVerified
                                    ? AppTheme.brandGreen
                                    : AppTheme.brandDanger,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 28),
            _SettingsListSection(
              items: const [
                _SettingsTileData(
                  icon: Icons.person_outline,
                  title: 'Profile',
                  subtitle: 'Manage your profile',
                ),
                _SettingsTileData(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage notification preferences',
                ),
                _SettingsTileData(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy',
                  subtitle: 'Privacy settings',
                ),
                _SettingsTileData(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  subtitle: 'Get help and support',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsListSection extends StatelessWidget {
  const _SettingsListSection({required this.items});

  final List<_SettingsTileData> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 16),
            child: _SettingsListTile(data: items[i]),
          ),
      ],
    );
  }
}

class _SettingsListTile extends StatelessWidget {
  const _SettingsListTile({required this.data});

  final _SettingsTileData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.brandBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.cardShadow,
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.brandBullet,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Icon(
            data.icon,
            color: AppTheme.brandBlack,
          ),
        ),
        title: Text(
          data.title,
          style: const TextStyle(
            color: AppTheme.brandBlack,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          data.subtitle,
          style: TextStyle(
            color: AppTheme.brandBlack.withValues(alpha: 0.6),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppTheme.brandBlack,
        ),
        onTap: () {},
      ),
    );
  }
}

class _SettingsTileData {
  const _SettingsTileData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}