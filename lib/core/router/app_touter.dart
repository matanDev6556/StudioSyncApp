import 'package:get/get.dart';
import 'package:studiosync/core/router/shared_routes_router.dart';
import 'package:studiosync/core/router/trainee_routes_router.dart';
import 'package:studiosync/core/router/trainer_routes_router.dart';

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
}
