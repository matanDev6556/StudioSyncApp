import 'package:get/get.dart';
import 'package:studiosync/core/data/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/auth/domain/usecases/get_current_useruid_usecase.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_lessons_controller.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_lessons_settings.controller%20.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_statistic_controller.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/filter_lessons_service.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/lessons_crud_service.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/trainer_lessons_service.dart';
import 'package:studiosync/core/presentation/controllers/tabs_controller.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/presentation/trainees_binding.dart';
import 'package:studiosync/modules/trainer/features/notifications/presentation/requests_binding.dart';
import 'package:studiosync/modules/trainer/features/profile/presentation/trainer_profile_bindings.dart';

class TrainerTabsBinding extends Bindings {
  final firestoreService = Get.find<FirestoreService>();
  @override
  void dependencies() {
    // genetrals
    Get.put(GeneralTabController([
      'Profile',
      'Clients',
      'Sessions',
    ]));
    // requests tab
    RequestsBinding().dependencies();
    // profile
    TrainerProfileBindings().dependencies();
    // clients
    TraineesListBinding().dependencies();

    _bindSessionsTab();
    _bindStatisticsTab();
  }

  void _bindSessionsTab() {
    Get.lazyPut(() => TrainerLessonsService(firestoreService));
    Get.lazyPut(() => LessonTrainerFilterService());
    Get.lazyPut(() => LessonsCrudService(trainerLessonsService: Get.find()));
    Get.put(TrainerLessonsController(
      getCurrentUserIdUseCase: Get.find<GetCurrentUserIdUseCase>(),
      trainerLessonsService: Get.find(),
      filterService: Get.find(),
      crudService: Get.find(),
    ));
    Get.put(
        TrainerLessonsSettingsController(firestoreService: firestoreService));
  }

  void _bindStatisticsTab() {
    Get.lazyPut(() => TrainerStatsController(Get.find(),Get.find<GetCurrentUserIdUseCase>()));
  }
}
