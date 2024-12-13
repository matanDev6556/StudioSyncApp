import 'package:get/get.dart';
import 'package:studiosync/modules/auth/views/signip_trainee_view.dart';
import 'package:studiosync/modules/trainee/features/tabs/bindings/trainee_tabs_binding.dart';
import 'package:studiosync/modules/trainee/bindings/trainer_lessons_binding.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/presentation/bindings/trainers_list_binding.dart';
import 'package:studiosync/modules/trainee/features/lessons/views/trainer_lessons_view.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/presentation/views/trainer_profile_view.dart';
import 'package:studiosync/modules/trainee/features/tabs/view/tabs_trainee_view.dart';
import 'package:studiosync/modules/auth/bindings/signup_trainee_binding.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/presentation/views/trainers_list_view.dart';

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
      name: Routes.trainerProfile,
      page: () => TrainerProfileView(
        trainerModel: Get.arguments,
      ),
    ),
    GetPage(
      name: Routes.trainersList,
      page: () => const TrainersListView(),
      binding: TrainersListBinding(),
    ),
    GetPage(
        name: Routes.trainerLessons,
        page: () => const TrainerLessonsView(),
        binding: TrainerLessonsBinding()),

    // Add other trainee-specific routes here
  ];
}
