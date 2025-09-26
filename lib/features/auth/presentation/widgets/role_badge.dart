import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../shared/utils/role_permissions.dart';

class RoleBadge extends StatelessWidget {
  final UserRole role;
  final double? fontSize;
  final double? padding;
  final bool showIcon;

  const RoleBadge({
    super.key,
    required this.role,
    this.fontSize = 14,
    this.padding = 8,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final roleColor = Color(int.parse(
      RolePermissions.getRoleColor(role).replaceFirst('#', '0xFF'),
    ));

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: padding!,
        vertical: padding! * 0.75,
      ),
      decoration: BoxDecoration(
        color: roleColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: roleColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: roleColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              RolePermissions.getRoleDisplayName(role),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: roleColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoleIcon extends StatelessWidget {
  final UserRole role;
  final double size;

  const RoleIcon({
    super.key,
    required this.role,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final roleColor = Color(int.parse(
      RolePermissions.getRoleColor(role).replaceFirst('#', '0xFF'),
    ));

    IconData iconData;
    switch (role) {
      case UserRole.admin:
        iconData = Icons.admin_panel_settings;
        break;
      case UserRole.manager:
        iconData = Icons.supervisor_account;
        break;
      case UserRole.hr:
        iconData = Icons.people;
        break;
      case UserRole.salesEngineer:
        iconData = Icons.trending_up;
        break;
      case UserRole.softwareEngineer:
        iconData = Icons.code;
        break;
    }

    return Icon(
      iconData,
      color: roleColor,
      size: size,
    );
  }
}