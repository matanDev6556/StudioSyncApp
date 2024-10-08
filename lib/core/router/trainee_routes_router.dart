import 'package:get/get.dart';
import 'package:studiosync/modules/auth/views/signip_trainee_view.dart';
import 'package:studiosync/modules/trainee/views/tabs_trainee_view.dart';
import 'package:studiosync/modules/auth/bindings/signup_trainee_binding.dart';
import 'package:studiosync/core/router/routes.dart';

class TraineeRouter {
  static final traineeRoutes = [
    GetPage(
      name: Routes.signUpTrainee,
      page: () => const SignUpTraineeView(),
      binding: SignUpTraineeBinding(),
    ),
    GetPage(
      name: Routes.homeTrainee,
      page: () => const TraineeTabsView(),
    ),
    // Add other trainee-specific routes here
  ];
}
