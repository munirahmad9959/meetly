import '../entities/user_entity.dart';

abstract class AuthRepository {
  // Get current user stream
  Stream<UserEntity?> get authStateChanges;
  
  // Get current user
  UserEntity? get currentUser;
  
  // Authentication methods
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  
  Future<UserEntity> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    UserRole role = UserRole.softwareEngineer,
  });
  
  Future<void> signOut();
  
  Future<void> resetPassword({required String email});
  
  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
  });
  
  Future<void> updateUserRole(String userId, UserRole role);
  Future<UserEntity?> getUserFromFirestore(String userId);
}