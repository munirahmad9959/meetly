import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Stream<UserEntity?> get authStateChanges =>
      _remoteDataSource.authStateChanges.map((userModel) => userModel?.toEntity());

  @override
  UserEntity? get currentUser => _remoteDataSource.currentUser?.toEntity();

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userModel = await _remoteDataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final userModel = await _remoteDataSource.registerWithEmailAndPassword(
      email: email,
      password: password,
      fullName: fullName,
    );
    return userModel.toEntity();
  }

  @override
  Future<void> signOut() async {
    await _remoteDataSource.signOut();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _remoteDataSource.resetPassword(email: email);
  }

  @override
  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    await _remoteDataSource.updateUserProfile(
      displayName: displayName,
      photoUrl: photoUrl,
    );
  }
}