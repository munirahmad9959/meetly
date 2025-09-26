import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../shared/utils/role_permissions.dart';

class RoleSelector extends StatelessWidget {
  final UserRole selectedRole;
  final ValueChanged<UserRole?> onChanged;
  final String? Function(UserRole?)? validator;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<UserRole>(
        initialValue: selectedRole,
        isExpanded: true,
        decoration: const InputDecoration(
          labelText: 'Role',
          hintText: 'Select your role',
          prefixIcon: Icon(Icons.work_outline),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        items: UserRole.values.map((UserRole role) {
          return DropdownMenuItem<UserRole>(
            value: role,
            child: RoleItem(role: role),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
        dropdownColor: Colors.white,
        iconEnabledColor: Colors.grey.shade600,
      ),
    );
  }
}

class RoleItem extends StatelessWidget {
  final UserRole role;

  const RoleItem({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Color(int.parse(
              RolePermissions.getRoleColor(role).replaceFirst('#', '0xFF'),
            )),
            shape: BoxShape.circle,
          ),
        ),
        Flexible(
          child: Text(
            RolePermissions.getRoleDisplayName(role),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }


}