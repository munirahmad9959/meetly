import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.fullName,
    super.photoUrl,
    required super.emailVerified,
    required super.role,
    super.createdAt,
  });

  // Convert from Firebase User to UserModel
  factory UserModel.fromFirebaseUser(User user, {UserRole role = UserRole.softwareEngineer}) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      fullName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      role: role,
      createdAt: user.metadata.creationTime,
    );
  }

  // Convert UserModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'emailVerified': emailVerified,
      'role': role.name,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  // Create UserModel from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? map['displayName'], // Support both for migration
      photoUrl: map['photoUrl'],
      emailVerified: map['emailVerified'] ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      role: _roleFromString(map['role'] ?? 'softwareEngineer'),
    );
  }

  // Convert to UserEntity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      fullName: fullName,
      photoUrl: photoUrl,
      emailVerified: emailVerified,
      role: role,
      createdAt: createdAt,
    );
  }

  static UserRole _roleFromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.name == role,
      orElse: () => UserRole.softwareEngineer,
    );
  }
}
