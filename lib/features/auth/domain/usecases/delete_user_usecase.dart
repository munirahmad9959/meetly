import '../../data/datasources/firestore_data_source.dart';

class DeleteUserUseCase {
  final FirestoreDataSource _firestoreDataSource;

  DeleteUserUseCase(this._firestoreDataSource);

  Future<void> call(String userId) async {
    await _firestoreDataSource.deleteUser(userId);
  }
}
