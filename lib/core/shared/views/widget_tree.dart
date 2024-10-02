import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/services/firebase/auth_service.dart';
import 'package:studiosync/modules/auth/views/login_view.dart';
import 'package:studiosync/core/shared/controllers/user_controller.dart';

// when user get inside the app he will first go to widget tree for check if
// the user already sign up or not, also whe check if the user is trainer or trainee
// and accordanly take user data and move to current home screen

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final authService = Get.find<AuthService>();
  final userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    // Start listening to auth changes
    authService.authStateChanges.listen((user) {
      if (user != null) {
        userController.checkUserRoleAndRedirect();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return const LoginView();
        }
      },
    );
  }
}
