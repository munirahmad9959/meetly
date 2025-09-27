import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../../shared/utils/notification_helper.dart';
import '../../../../shared/utils/loading_overlay.dart';
import '../../../auth/presentation/widgets/role_badge.dart';
import '../../../auth/presentation/widgets/role_welcome_message.dart';
import '../../../auth/presentation/widgets/admin_user_management.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../auth/domain/entities/user_entity.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meetly'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        
      ),
      
    );
  }
}