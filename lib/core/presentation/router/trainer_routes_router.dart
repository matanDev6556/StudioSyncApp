import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/bindings/trainee_profile_binding.dart';
import 'package:studiosync/modules/trainer/features/tabs/trainer_tabs_binding.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/views/trainee_workout_view.dart';
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
      page: () => const TrainerTabsView(),
      binding: TrainerTabsBinding(),
    ),
    GetPage(
      name: Routes.profileTrainee,
      page: () {
        final trainee = Get.arguments as TraineeModel;
        return TraineeWorkoutView(trainee: trainee);
      },
      binding: TraineeProfileBinding(),
    ),
   
  ];
}
