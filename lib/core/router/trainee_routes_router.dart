import 'package:get/get.dart';
import 'package:studiosync/modules/auth/views/signip_trainee_view.dart';
import 'package:studiosync/modules/trainee/bindings/trainee_tabs_binding.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/views/trainer_profile_view.dart';
import 'package:studiosync/modules/trainee/features/tabs_trainee_view.dart';
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
      binding: TraineeTabsBinding(),
    ),
    GetPage(
      name: Routes.myTrainerProfile,
      page: () => TrainerProfileView(
        trainerModel: Get.arguments,
      ),
    ),

    // Add other trainee-specific routes here
  ];
}
