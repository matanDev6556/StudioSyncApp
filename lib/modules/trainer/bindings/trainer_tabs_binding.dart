import 'package:get/get.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_lessons_controller.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/filter_lessons_service.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/trainer_lessons_service.dart';
import 'package:studiosync/shared/controllers/tabs_controller.dart';
import 'package:studiosync/modules/trainer/contollers/trainees_controller.dart';
import 'package:studiosync/modules/trainer/features/trainees/services/trainees_service.dart';
import 'package:studiosync/modules/trainer/features/trainees/services/trainess_filter_service.dart';

class TrainerTabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GeneralTabController(['Profile', 'Clients', 'Sessions']));

    _bindProfileTab();
    _bindClientsTab();
    _bindSessionsTab();
  }

  void _bindProfileTab() {}

  void _bindClientsTab() {
    Get.lazyPut(() => TraineeListService(Get.find()));
    Get.lazyPut(() => TraineeFilterService());
    Get.put(TraineesController(Get.find(), Get.find(), Get.find()));
  }

  void _bindSessionsTab() {
    Get.lazyPut(() => TrainerLessonsService(Get.find()));
    Get.lazyPut(() => LessonFilterService());
    Get.put(TrainerLessonsController(
      trainerLessonsService: Get.find(),
      trainerController: Get.find(),
      filterService: Get.find(),
    ));
  }
}
