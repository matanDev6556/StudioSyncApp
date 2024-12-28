import 'package:get/get.dart';
import 'package:studiosync/modules/auth/presentation/views/signup_trainee_view.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/views/upcoming_lessons_view.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/views/trainee_profile_view.dart';
import 'package:studiosync/modules/trainee/features/tabs/bindings/trainee_tabs_binding.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/bindings/trainer_lessons_binding.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/presentation/bindings/profile_trainer_binding.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/presentation/bindings/trainers_list_binding.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/views/trainer_lessons_view.dart';
import 'package:studiosync/modules/trainee/features/tabs/view/tabs_trainee_view.dart';
import 'package:studiosync/modules/auth/presentation/bindings/signup_trainee_binding.dart';
import 'package:studiosync/core/presentation/router/routes.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/presentation/views/trainer_profile_view.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/presentation/views/trainers_list_view.dart';
import 'package:studiosync/modules/trainee/features/workouts/presentation/views/workouts_view.dart';

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
      name: Routes.workoutesTrainee,
      page: () => TraineeWorkoutsView(),
      binding: WorkoutsTraineeTabBinding(),
    ),
    GetPage(
      name: Routes.lessonsTrainee,
      page: () => const UpcomingLessonsView(),
      binding: LessonsTraineeTabBinding(),
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
        binding: ProfileTrainerBinding()),
    GetPage(
        name: Routes.trainerLessons,
        page: () => const TrainerLessonsView(),
        binding: TrainerLessonsBinding()),

    // Add other trainee-specific routes here
  ];
}
