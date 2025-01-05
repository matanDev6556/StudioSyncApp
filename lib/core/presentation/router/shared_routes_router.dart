import 'package:get/get.dart';
import 'package:studiosync/core/presentation/router/routes.dart';
import 'package:studiosync/modules/auth/presentation/bindings/login_bindng.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/workouts/presentation/views/all_workoutes_view.dart';
import 'package:studiosync/core/presentation/views/splash_view.dart';
import 'package:studiosync/modules/auth/presentation/views/login_view.dart';
import 'package:studiosync/modules/auth/presentation/views/signup_as_view.dart';
import 'package:studiosync/modules/widget-tree/presentation/widget_tree_binding.dart';
import 'package:studiosync/modules/widget-tree/presentation/widget_tree_view.dart';

class SharedRoutes {
  static final sharedRoutes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: Routes.widgetTree,
      page: () => const WidgetTreeView(),
      binding: WidgetTreeBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.signUpAs,
      page: () => const SignUpAsView(),
    ),
    GetPage(
      name: Routes.allTraineeWorkouts,
      page: () => AllWorkoutsView(
        workouts: Get.arguments['workouts'],
        onEdit: Get.arguments['onEdit'],
        onDelete: Get.arguments['onDelete'],
        workoutSummary: Get.arguments['summary'],
      ),
    ),

 
    // Add other shared routes here
  ];
}
