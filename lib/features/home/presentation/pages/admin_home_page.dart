import 'package:flutter/material.dart';
import 'package:meetly/features/home/presentation/pages/admin_dashboard_page.dart';
import 'package:meetly/features/home/presentation/pages/admin_rooms_page.dart';
import 'package:meetly/features/home/presentation/pages/admin_users_page.dart';
import 'package:meetly/features/settings/presentation/pages/settings_page.dart';
import 'package:meetly/shared/theme/app_theme.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final PageStorageBucket _bucket = PageStorageBucket();
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const AdminDashboardPage(key: PageStorageKey('admin-dashboard')),
    const AdminRoomsPage(key: PageStorageKey('admin-rooms')),
    const AdminUsersPage(key: PageStorageKey('admin-users')),
    const SettingsPage(key: PageStorageKey('admin-settings')),
  ];

  @override
  Widget build(BuildContext context) {
    final unselectedColor = AppTheme.brandBg.withOpacity(0.6);

    return Scaffold(
      backgroundColor: AppTheme.brandBlack,
      body: PageStorage(
        bucket: _bucket,
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.brandBlack,
          boxShadow: const [
            BoxShadow(
              color: Color(0x28000000),
              blurRadius: 12,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: AppTheme.brandBlack,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppTheme.brandGreen,
            unselectedItemColor: unselectedColor,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.space_dashboard_outlined),
                activeIcon: Icon(Icons.space_dashboard_rounded),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.meeting_room_outlined),
                activeIcon: Icon(Icons.meeting_room_rounded),
                label: 'Rooms',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people_alt_rounded),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.manage_accounts_outlined),
                activeIcon: Icon(Icons.manage_accounts_rounded),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}