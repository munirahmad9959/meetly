import '../entities/user_entity.dart';
import '../../data/datasources/firestore_data_source.dart';

class UpdateUserUseCase {
  final FirestoreDataSource _firestoreDataSource;

  UpdateUserUseCase(this._firestoreDataSource);

  Future<void> call({
    required String userId,
    String? fullName,
    UserRole? role,
  }) async {
    final updates = <String, dynamic>{};
    
    if (fullName != null) {
      updates['fullName'] = fullName;
    }
    
    if (role != null) {
      updates['role'] = role.name;
    }

    if (updates.isEmpty) {
      throw Exception('No updates provided');
    }

    await _firestoreDataSource.updateUser(userId, updates);
  }
}
