import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/services/iauth_service.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/modules/auth/const_auth.dart';
import 'package:studiosync/core/router/routes.dart';

class LoginController extends GetxController {
  final IAuthService _authService;

  LoginController(this._authService);

  var email = ''.obs;
  var password = ''.obs;
  var loginStatus = LoginStatus.idle.obs;


  void setEmail(String newEmail) => email.value = newEmail;
  void setPassword(String newPassword) => password.value = newPassword;

  void login() async {
    loginStatus.value = LoginStatus.submitting;
  
    try {
      if (_validate()) {
        await _authService.signInWithEmailAndPassword(
            email.value, password.value);

        loginStatus.value = LoginStatus.success;
        Get.toNamed(Routes.widgetTree);
      }
    } catch (e) {
      loginStatus.value = LoginStatus.failure;
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    }
  }

  void logout() async {
    await _authService.signOut();
    Get.offAllNamed(Routes.login);
  }

  bool _validate() {
    var emailVal = Validations.validateEmail(email.value);
    var passVal = Validations.validateEmptey(password.value, 'Password');

    if (emailVal != null || passVal != null) {
      Validations.showValidationSnackBar(emailVal ?? passVal ?? '', Colors.red);
      loginStatus.value = LoginStatus.failure;
      return false;
    }
    return true;
  }
}
