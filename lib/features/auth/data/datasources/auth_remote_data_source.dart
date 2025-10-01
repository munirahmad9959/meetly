import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import 'firestore_data_source.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  UserModel? get currentUser;
  
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    UserRole role = UserRole.softwareEngineer,
    bool isAdmin = false,
  });
  
  Future<void> signOut();
  Future<void> resetPassword({required String email});
  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
  });
  
  Future<void> updateUserRole(String userId, UserRole role);
  Future<UserModel?> getUserFromFirestore(String userId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirestoreDataSource _firestoreDataSource;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirestoreDataSource? firestoreDataSource,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestoreDataSource = firestoreDataSource ?? FirestoreDataSourceImpl();

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      
      // Try to get user data from Firestore first
      final firestoreUser = await _firestoreDataSource.getUser(user.uid);
      if (firestoreUser != null) {
        return firestoreUser;
      }
      
      // If no Firestore data, create from Firebase Auth user with default role
      return UserModel.fromFirebaseUser(user, role: UserRole.softwareEngineer);
    });
  }

  @override
  UserModel? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    
    // Note: This is synchronous, so we return with default role
    // For complete user data with role, use getUserFromFirestore method
    return UserModel.fromFirebaseUser(user, role: UserRole.softwareEngineer);
  }
  
  // Additional method to get user data from Firestore
  Future<UserModel?> getUserFromFirestore(String userId) async {
    try {
      return await _firestoreDataSource.getUser(userId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user == null) {
        throw Exception('Failed to sign in user');
      }
      
      // Try to get user data from Firestore
      final firestoreUser = await _firestoreDataSource.getUser(result.user!.uid);
      if (firestoreUser != null) {
        return firestoreUser;
      }
      
      // If no Firestore data, create from Firebase Auth user with default role
      return UserModel.fromFirebaseUser(result.user!, role: UserRole.softwareEngineer);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    UserRole role = UserRole.softwareEngineer,
    bool isAdmin = false,
  }) async {
    try {
      if (isAdmin) {
        // Use secondary app to avoid affecting main auth state
        final secondaryApp = await Firebase.initializeApp(
          name: 'secondary',
          options: Firebase.app().options,
        );
        final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
        
        final UserCredential result = await secondaryAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        if (result.user == null) {
          await secondaryApp.delete();
          throw Exception('Failed to create user');
        }

        // Update user display name
        await result.user!.updateDisplayName(fullName);
        
        // Create user model with role
        final userModel = UserModel.fromFirebaseUser(
          result.user!,
          role: role,
        );
        
        // Save user data to Firestore
        await _firestoreDataSource.saveUser(userModel);
        
        // Sign out and delete secondary app
        await secondaryAuth.signOut();
        await secondaryApp.delete();
        
        return userModel;
      } else {
        // Normal registration
        final UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        if (result.user == null) {
          throw Exception('Failed to create user');
        }

        // Update user display name
        await result.user!.updateDisplayName(fullName);
        
        // Create user model with role
        final userModel = UserModel.fromFirebaseUser(
          result.user!,
          role: role,
        );
        
        // Save user data to Firestore
        await _firestoreDataSource.saveUser(userModel);
        
        return userModel;
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Error signing out: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No user currently signed in');
      }

      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }
    } catch (e) {
      throw Exception('Error updating profile: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserRole(String userId, UserRole role) async {
    try {
      await _firestoreDataSource.updateUser(userId, {'role': role.name});
    } catch (e) {
      throw Exception('Error updating user role: ${e.toString()}');
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}