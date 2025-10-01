import '../entities/user_entity.dart';
import '../../data/datasources/firestore_data_source.dart';

class GetAllUsersUseCase {
  final FirestoreDataSource _firestoreDataSource;

  GetAllUsersUseCase(this._firestoreDataSource);

  Future<List<UserEntity>> call() async {
    final users = await _firestoreDataSource.getAllUsers();
    return users.map((model) => model.toEntity()).toList();
  }
}
