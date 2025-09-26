enum UserRole { admin, softwareEngineer, hr, salesEngineer, manager }

class UserEntity {
  final String id;
  final String email;
  final String? fullName;
  final String? photoUrl;
  final bool emailVerified;
  final DateTime? createdAt;
  final UserRole role;

  const UserEntity({
    required this.id,
    required this.email,
    this.fullName,
    this.photoUrl,
    required this.emailVerified,
    this.createdAt,
    required this.role,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, fullName: $fullName, role: $role)';
  }
}
