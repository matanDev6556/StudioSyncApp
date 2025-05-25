import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/trainee-sections/binding_profile_trainee_sections.dart';
import 'package:studiosync/modules/trainer/features/tabs/trainer_tabs_binding.dart';
import 'package:studiosync/modules/trainer/features/trainee-sections/view_profile_trainee_sections.dart';
import 'package:studiosync/modules/trainer/features/tabs/trainer_tabs_view.dart';
import 'package:studiosync/modules/auth/presentation/views/signup_trainer_view.dart';
import 'package:studiosync/modules/auth/presentation/bindings/signup_trainer_binding.dart';
import 'package:studiosync/core/presentation/router/routes.dart';

class TrainerRouter {
  static final trainerRoutes = [
    GetPage(
      name: Routes.signUpTrainer,
      page: () => const SignUpTrainerView(),
      binding: SignUpTrainerBinding(),
    ),
    GetPage(
      name: Routes.homeTrainer,
      page: () =>  TrainerTabsView(),
      binding: TrainerTabsBinding(),
    ),
    GetPage(
      name: Routes.profileTrainee,
      page: () {
        final trainee = Get.arguments as TraineeModel;
        return ProfileOfTraineeView(trainee: trainee);
      },
      binding: TraineeProfileBinding(),
    ),
  ];
}
