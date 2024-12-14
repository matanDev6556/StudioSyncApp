import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/router/app_touter.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/modules/auth/domain/usecases/login_usecase.dart';
import 'package:studiosync/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:studiosync/modules/auth/presentation/utils/const_auth.dart';
import 'package:studiosync/core/router/routes.dart';

class LoginController extends GetxController {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  LoginController(this._loginUseCase, this._logoutUseCase);

  var email = ''.obs;
  var password = ''.obs;
  var loginStatus = LoginStatus.idle.obs;

  void setEmail(String newEmail) => email.value = newEmail;
  void setPassword(String newPassword) => password.value = newPassword;

  void login() async {
    loginStatus.value = LoginStatus.submitting;

    try {
      bool isValid = await _loginUseCase.execute(email.value, password.value);
      if (isValid) {
        loginStatus.value = LoginStatus.success;
        AppRouter.navigateTo(Routes.widgetTree);
      } else {
        loginStatus.value = LoginStatus.failure;
      }
    } catch (e) {
      loginStatus.value = LoginStatus.failure;
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    }
  }

  void logout() async {
    await _logoutUseCase.call();
    AppRouter.navigateOffAllNamed(Routes.login);
  }
}
