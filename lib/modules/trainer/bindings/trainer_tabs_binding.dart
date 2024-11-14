import 'package:get/get.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainer/contollers/requests_controller.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_lessons_controller.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_lessons_settings.controller%20.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_statistic_controller.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/filter_lessons_service.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/lessons_crud_service.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/trainer_lessons_service.dart';
import 'package:studiosync/shared/controllers/tabs_controller.dart';
import 'package:studiosync/modules/trainer/contollers/trainees_controller.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/services/trainees_service.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/services/trainess_filter_service.dart';

class TrainerTabsBinding extends Bindings {
  final firestoreService = Get.find<FirestoreService>();
  @override
  void dependencies() {
    Get.put(GeneralTabController([
      'Profile',
      'Clients',
      'Sessions',
    ]));
    Get.put(RequestsController(firestoreService: firestoreService));

    _bindProfileTab();
    _bindClientsTab();
    _bindSessionsTab();
    _bindStatisticsTab();
  }

  void _bindProfileTab() {}

  void _bindClientsTab() {
    Get.lazyPut(() => TraineeListService(firestoreService));
    Get.lazyPut(() => TraineeFilterService());
    Get.put(TraineesController(Get.find(), Get.find(), Get.find()));
  }

  void _bindSessionsTab() {
    Get.lazyPut(() => TrainerLessonsService(firestoreService));
    Get.lazyPut(() => LessonTrainerFilterService());
    Get.lazyPut(() => LessonsCrudService(trainerLessonsService: Get.find()));
    Get.put(TrainerLessonsController(
      trainerLessonsService: Get.find(),
      trainerController: Get.find(),
      filterService: Get.find(),
      crudService: Get.find(),
    ));
    Get.put(
        TrainerLessonsSettingsController(firestoreService: firestoreService));
  }

  void _bindStatisticsTab() {
    Get.lazyPut(() => TrainerStatsController(Get.find()));
  }
}
