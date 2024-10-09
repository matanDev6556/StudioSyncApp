import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/bindings/trainee_profile_binding.dart';
import 'package:studiosync/modules/trainer/views/trainee_profile.dart/trainee_profile_view.dart';
import 'package:studiosync/modules/trainer/bindings/trainer_tabs_binding.dart';
import 'package:studiosync/modules/trainer/views/trainer_tabs_view.dart';
import 'package:studiosync/modules/auth/views/signup_trainer_view.dart';
import 'package:studiosync/modules/auth/bindings/signup_trainer_binding.dart';
import 'package:studiosync/core/router/routes.dart';

class TrainerRouter {
  static final trainerRoutes = [
    GetPage(
      name: Routes.signUpTrainer,
      page: () => const SignUpTrainerView(),
      binding: SignUpTrainerBinding(),
    ),
    GetPage(
      name: Routes.homeTrainer,
      page: () => const TrainerTabsView(),
      binding: TrainerTabsBinding(),
    ),
    GetPage(
      name: Routes.profileTrainee,
      page: () {
        final trainee = Get.arguments as TraineeModel;
        return TraineeProfileView(trainee: trainee);
      },
      binding: TraineeProfileBinding(),
    ),
    // Add other trainer-specific routes here
  ];
}
