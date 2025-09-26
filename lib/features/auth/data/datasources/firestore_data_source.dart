import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

abstract class FirestoreDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser(String userId);
  Future<void> updateUser(String userId, Map<String, dynamic> updates);
  Future<void> deleteUser(String userId);
  Stream<UserModel?> getUserStream(String userId);
  Future<List<UserModel>> getAllUsers();
  Stream<List<UserModel>> getAllUsersStream();
}

class FirestoreDataSourceImpl implements FirestoreDataSource {
  final FirebaseFirestore _firestore;
  static const String _usersCollection = 'users';

  FirestoreDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore.collection(_usersCollection).doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to save user: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(userId).get();
      
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update(updates);
    } catch (e) {
      throw Exception('Failed to update user: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user: ${e.toString()}');
    }
  }

  @override
  Stream<UserModel?> getUserStream(String userId) {
    try {
      return _firestore
          .collection(_usersCollection)
          .doc(userId)
          .snapshots()
          .map((doc) {
        if (doc.exists && doc.data() != null) {
          return UserModel.fromMap(doc.data()!);
        }
        return null;
      });
    } catch (e) {
      throw Exception('Failed to get user stream: ${e.toString()}');
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
    final snapshot = await _firestore
      .collection(_usersCollection)
      .orderBy('createdAt', descending: false)
      .get();
    return snapshot.docs
      .map((doc) => UserModel.fromMap(doc.data()))
      .toList();
    } catch (e) {
      throw Exception('Failed to get users: ${e.toString()}');
    }
  }

  @override
  Stream<List<UserModel>> getAllUsersStream() {
    try {
    return _firestore
      .collection(_usersCollection)
      .orderBy('createdAt', descending: false)
          .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data()))
        .toList());
    } catch (e) {
      throw Exception('Failed to get users stream: ${e.toString()}');
    }
  }
}