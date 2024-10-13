import 'package:get/get.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/views/all_workoutes_view.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/views/workout_analytic_view.dart';
import 'package:studiosync/shared/bindings/widget_tree_binding.dart';
import 'package:studiosync/shared/views/splash_view.dart';
import 'package:studiosync/shared/views/widget_tree.dart';
import 'package:studiosync/modules/auth/views/login_view.dart';
import 'package:studiosync/modules/auth/bindings/login_binding.dart';
import 'package:studiosync/modules/auth/views/signup_as_view.dart';

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
      name: Routes.allTraineeWorkouts,
      page: () => const AllWorkoutsView(),
    ),

      GetPage(
      name: Routes.workoutsAnalytic,
      page: () => const WorkoutAnalyticView(),
    ),
    // Add other shared routes here
  ];
}
