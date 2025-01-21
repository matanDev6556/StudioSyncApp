import 'package:flutter/material.dart';
import 'package:studiosync/core/presentation/utils/validations.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';

class LoginUseCase {
  final IAuthRepository _authRepository;

  LoginUseCase(this._authRepository);
  Future<bool> execute(String email, String password) async {
    var emailVal = Validations.validateEmail(email);
    var passVal = Validations.validateEmptey(password, 'Password');

    if (emailVal == null && passVal == null) {
      final user =
          await _authRepository.signInWithEmailAndPassword(email, password);
      return user != null;
    } else {
      Validations.showValidationSnackBar(emailVal ?? passVal ?? '', Colors.red);
      return false;
    }
  }
}
