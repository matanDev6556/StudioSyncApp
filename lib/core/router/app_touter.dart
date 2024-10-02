import 'package:get/get.dart';
import 'package:studiosync/core/shared/bindings/widget_tree_binding.dart';
import 'package:studiosync/modules/auth/bindings/login_binding.dart';
import 'package:studiosync/modules/auth/bindings/signup_trainee_binding.dart';
import 'package:studiosync/modules/auth/bindings/signup_trainer_binding.dart';
import 'package:studiosync/modules/auth/views/login_view.dart';
import 'package:studiosync/modules/auth/views/signip_trainee_view.dart';
import 'package:studiosync/modules/auth/views/signup_as_view.dart';
import 'package:studiosync/modules/auth/views/signup_trainer_view.dart';
import 'package:studiosync/core/shared/views/splash_view.dart';
import 'package:studiosync/modules/trainee/views/tabs_trainee_view.dart';
import 'package:studiosync/modules/trainer/bindings/trainer_tabs_binding.dart';
import 'package:studiosync/modules/trainer/views/trainer_tabs_view.dart';
import 'package:studiosync/core/shared/views/widget_tree.dart';
import 'package:studiosync/core/router/routes.dart';

class AppRouter {
  static final routes = [
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
      name: Routes.signUpTrainer,
      page: () => const SignUpTrainerView(),
      binding: SignUpTrainerBinding(),
    ),
    GetPage(
      name: Routes.signUpTrainee,
      page: () => const SignUpTraineeView(),
      binding: SignUpTraineeBinding(),
    ),
    GetPage(
      name: Routes.homeTrainee,
      page: () => const TraineeTabsView(),
      
      //binding: SignUpTraineeBinding(),
    ),
    GetPage(
      name: Routes.homeTrainer,
      page: () => const TrainerTabsView(),
      binding: TrainerTabsBinding(),
    ),
  ];
}
