import '../../features/auth/domain/entities/user_entity.dart';

class RolePermissions {
  /// Check if user has admin permissions
  static bool isAdmin(UserEntity user) {
    return user.role == UserRole.admin;
  }

  /// Check if user has HR permissions
  static bool isHR(UserEntity user) {
    return user.role == UserRole.hr || isAdmin(user);
  }

  /// Check if user has manager permissions
  static bool isManager(UserEntity user) {
    return user.role == UserRole.manager || isAdmin(user);
  }

  /// Check if user can manage other users
  static bool canManageUsers(UserEntity user) {
    return isAdmin(user) || isHR(user);
  }

  /// Check if user can view all meetings
  static bool canViewAllMeetings(UserEntity user) {
    return isAdmin(user) || isManager(user);
  }

  /// Check if user can create meetings
  static bool canCreateMeetings(UserEntity user) {
    return user.role != UserRole.softwareEngineer || 
           isManager(user) || 
           isAdmin(user);
  }

  /// Get role display name
  static String getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.softwareEngineer:
        return 'Software Engineer';
      case UserRole.hr:
        return 'Human Resources';
      case UserRole.salesEngineer:
        return 'Sales Engineer';
      case UserRole.manager:
        return 'Manager';
    }
  }

  /// Get all available roles (for admin to assign)
  static List<UserRole> getAllRoles() {
    return UserRole.values;
  }

  /// Get role color for UI
  static String getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return '#D95639'; // brand danger
      case UserRole.manager:
        return '#070707'; // brand black
      case UserRole.hr:
        return '#3FCD36'; // brand green
      case UserRole.salesEngineer:
        return '#070707'; // brand black
      case UserRole.softwareEngineer:
        return '#3FCD36'; // brand green
    }
  }
}