import 'package:get/get.dart';
import 'package:studiosync/core/presentation/router/shared_routes_router.dart';
import 'package:studiosync/core/presentation/router/trainee_routes_router.dart';
import 'package:studiosync/core/presentation/router/trainer_routes_router.dart';

class AppRouter {
  static final routes = [
    ...SharedRoutes.sharedRoutes,
    ...TrainerRouter.trainerRoutes,
    ...TraineeRouter.traineeRoutes,
  ];

  static void navigateTo(String routeName) {
    Get.toNamed(routeName);
  }

  static void navigateOffAllNamed(String routeName) {
    Get.offAllNamed(routeName);
  }

  static void navigateWithArgs(String routeName, dynamic arguments) {
    Get.toNamed(routeName, arguments: arguments);
  }

  static void navigateBack() {
    Get.back();
  }
}
