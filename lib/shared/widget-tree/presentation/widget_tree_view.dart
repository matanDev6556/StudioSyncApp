import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/modules/auth/presentation/views/login_view.dart';
import 'package:studiosync/shared/widget-tree/presentation/widget_tree_controller.dart';

class WidgetTreeView extends StatefulWidget {
  const WidgetTreeView({super.key});

  @override
  State<WidgetTreeView> createState() => _WidgetTreeViewState();
}

class _WidgetTreeViewState extends State<WidgetTreeView> {
  final authService = Get.find<IAuthRepository>();
  final controller = Get.find<WidgetTreeController>();

     @override
  void initState() {
    super.initState();
    // Start listening to auth changes
    authService.authStateChanges.listen((user) {
      if (user != null) {
        controller.chckUserAndRedirect();
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