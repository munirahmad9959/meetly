import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              subtitle: Text('Manage your profile'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              subtitle: Text('Manage notification preferences'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacy'),
              subtitle: Text('Privacy settings'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help & Support'),
              subtitle: Text('Get help and support'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}