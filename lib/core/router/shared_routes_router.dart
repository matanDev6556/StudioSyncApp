import 'package:get/get.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/core/shared/bindings/widget_tree_binding.dart';
import 'package:studiosync/core/shared/views/splash_view.dart';
import 'package:studiosync/core/shared/views/widget_tree.dart';
import 'package:studiosync/modules/auth/views/login_view.dart';
import 'package:studiosync/modules/auth/bindings/login_binding.dart';
import 'package:studiosync/modules/auth/views/signup_as_view.dart';
import 'package:studiosync/modules/trainee/models/workout.dart';
import 'package:studiosync/modules/trainee_profile.dart/all_workoutes_view.dart';

class SharedRoutes {
  static final sharedRoutes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: WidgetTreeBinding(),
    ),
    GetPage(
      name: Routes.widgetTree,
      page: () => const WidgetTree(),
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
      name: Routes.AllTraineeWorkouts,
      page: () {
        final workouts = Get.arguments as List<WorkoutModel>;
        return AllWorkoutsView(
          workouts: workouts,
        );
      },
    ),
    // Add other shared routes here
  ];
}
