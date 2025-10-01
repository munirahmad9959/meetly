import 'package:flutter/foundation.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import '../../domain/usecases/delete_user_usecase.dart';
import '../../domain/usecases/get_all_users_usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/datasources/firestore_data_source.dart';

class UsersProvider with ChangeNotifier {
  final FirestoreDataSource _firestoreDataSource;
  final SignUpUseCase _signUpUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;
  final GetAllUsersUseCase _getAllUsersUseCase;

  List<UserEntity> _users = [];
  bool _isLoading = false;
  String? _error;

  List<UserEntity> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  UsersProvider({
    required FirestoreDataSource firestoreDataSource,
    required SignUpUseCase signUpUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required DeleteUserUseCase deleteUserUseCase,
    required GetAllUsersUseCase getAllUsersUseCase,
  })  : _firestoreDataSource = firestoreDataSource,
        _signUpUseCase = signUpUseCase,
        _updateUserUseCase = updateUserUseCase,
        _deleteUserUseCase = deleteUserUseCase,
        _getAllUsersUseCase = getAllUsersUseCase {
    // start listening to users
    _firestoreDataSource.getAllUsersStream().listen((models) {
      _users = models.map((m) => m.toEntity()).toList();
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<void> loadUsers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _users = await _getAllUsersUseCase();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createUser({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _signUpUseCase(
        email: email,
        password: password,
        fullName: fullName.isNotEmpty ? fullName : 'User',
        role: role,
        isAdmin: true,
      );
      // Firestore user document will be created by AuthRemoteDataSource during registration
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser({
    required String userId,
    String? fullName,
    UserRole? role,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _updateUserUseCase(
        userId: userId,
        fullName: fullName,
        role: role,
      );
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _deleteUserUseCase(userId);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
