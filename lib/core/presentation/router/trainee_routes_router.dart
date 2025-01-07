import 'package:get/get.dart';
import 'package:studiosync/modules/auth/presentation/views/signup_trainee_view.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/bindings/registred_lessons_bindings.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/views/upcoming_lessons_view.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/views/trainee_profile_view.dart';
import 'package:studiosync/modules/trainee/features/tabs/trainee_tabs_binding.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/bindings/trainer_lessons_binding.dart';
import 'package:studiosync/modules/trainee/features/trainee-sections/trainee_sections_view.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/presentation/bindings/profile_trainer_binding.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/presentation/bindings/trainers_list_binding.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/views/trainer_lessons_view.dart';
import 'package:studiosync/modules/trainee/features/tabs/tabs_trainee_view.dart';
import 'package:studiosync/modules/auth/presentation/bindings/signup_trainee_binding.dart';
import 'package:studiosync/core/presentation/router/routes.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/presentation/views/trainer_profile_view.dart';
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
      name: Routes.profileTrainee,
      page: () => TraineeProfileView(),
      binding: ProfileTraineeTabBinding(),
    ),
    GetPage(
      name: Routes.sectionsTrainee,
      page: () => const TraineeSectionsView(),
    ),

    GetPage(
      name: Routes.lessonsTrainee,
      page: () => const UpcomingLessonsView(),
      binding: RegistredLessonsTabBinding(),
    ),

    GetPage(
      name: Routes.trainersList,
      page: () => const TrainersListView(),
      binding: TrainersListBinding(),
    ),
    GetPage(
        name: Routes.trainerProfile,
        page: () => TrainerProfileView(
              trainerModel: Get.arguments,
            ),
        binding: ProfileTraineeTabBinding()),
    GetPage(
        name: Routes.trainerLessons,
        page: () => const TrainerLessonsView(),
        binding: TrainerLessonsBinding()),

    // Add other trainee-specific routes here
  ];
}
