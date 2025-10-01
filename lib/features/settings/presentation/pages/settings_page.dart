import 'package:flutter/material.dart';
import 'package:meetly/features/auth/presentation/pages/login_page.dart';
import 'package:meetly/shared/theme/app_theme.dart';
import 'package:meetly/shared/utils/loading_overlay.dart';
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
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppTheme.brandBg,
            fontSize: 20, // Added consistent font size
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined, 
              color: AppTheme.brandBg,
              size: 24, // Consistent icon size
            ),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              try {
                LoadingOverlay.show(context, message: 'Signing out...');
                await authProvider.signOut();
                LoadingOverlay.hide();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              } catch (e) {
                LoadingOverlay.hide();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error signing out: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
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
                    borderRadius: BorderRadius.circular(24), // Reduced from 28 for better proportions
                    boxShadow: AppTheme.cardShadow,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 36, // Increased from 32 for better visibility
                            backgroundColor: AppTheme.brandBg,
                            backgroundImage: user.photoUrl != null
                                ? NetworkImage(user.photoUrl!)
                                : null,
                            child: user.photoUrl == null
                                ? RoleIcon(role: user.role, size: 36) // Consistent with avatar size
                                : null,
                          ),
                          const SizedBox(width: 16),

                          // user detail section(name,  email, role badge)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.fullName ?? 'User',
                                  style: const TextStyle(
                                    fontSize: 14, // Reduced from 20 for better hierarchy
                                    fontWeight: FontWeight.normal,
                                    color: AppTheme.brandBlack,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6), // Increased spacing
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.brandBlack.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12), // Increased spacing
                                RoleBadge(role: user.role),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Email verification section
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10, // Increased padding
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.brandBullet,
                          borderRadius: BorderRadius.circular(12), // Reduced from 16 for better proportions
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              user.emailVerified
                                  ? Icons.verified
                                  : Icons.warning_amber_rounded,
                              color: user.emailVerified
                                  ? AppTheme.brandGreen
                                  : AppTheme.brandDanger,
                              size: 17, 
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
                                fontSize: 10,
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
            padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 12), // Reduced from 16 for tighter grouping
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
        borderRadius: BorderRadius.circular(24), // Reduced from 24 for better proportions
        boxShadow: AppTheme.cardShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, // Added horizontal padding
          vertical: 8,    // Added vertical padding
        ),
        leading: Container(
          width: 48,  // Increased from 44 for better touch target
          height: 48, // Increased from 44 for better touch target
          decoration: BoxDecoration(
            color: AppTheme.brandBullet,
            borderRadius: BorderRadius.circular(24), // Reduced from 14 for better proportions
          ),
          alignment: Alignment.center,
          child: Icon(
            data.icon, 
            color: AppTheme.brandBlack,
            size: 18, // Added consistent icon size
          ),
        ),
        title: Text(
          data.title,
          style: const TextStyle(
            color: AppTheme.brandBlack,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),
        subtitle: Text(
          data.subtitle,
          style: TextStyle(
            color: AppTheme.brandBlack.withValues(alpha: 0.6),
            fontSize: 8, // Added consistent font size
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 12,
          color: AppTheme.brandBlack,
        ),
        onTap: () {
        },
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