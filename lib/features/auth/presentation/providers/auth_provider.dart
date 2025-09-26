import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/get_auth_state_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';

class AuthProvider with ChangeNotifier {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetAuthStateUseCase _getAuthStateUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  UserEntity? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  AuthProvider({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GetAuthStateUseCase getAuthStateUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _signOutUseCase = signOutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _getAuthStateUseCase = getAuthStateUseCase,
        _resetPasswordUseCase = resetPasswordUseCase {
    
    // Listen to auth state changes
    _getAuthStateUseCase().listen((UserEntity? user) {
      _user = user;
      notifyListeners();
    });
    
    // Set initial user
    _user = _getCurrentUserUseCase();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      final user = await _signInUseCase(
        email: email,
        password: password,
      );
      
      _user = user;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      _setLoading(true);
      _clearError();

      final user = await _signUpUseCase(
        email: email,
        password: password,
        fullName: fullName,
      );
      
      _user = user;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      _clearError();
      await _signOutUseCase();
      _user = null;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _clearError();
      await _resetPasswordUseCase(email: email);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}