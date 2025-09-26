import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<void> call({required String email}) async {
    if (email.isEmpty) {
      throw Exception('Email cannot be empty');
    }
    
    if (!_isValidEmail(email)) {
      throw Exception('Please enter a valid email address');
    }

    await _repository.resetPassword(email: email);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}