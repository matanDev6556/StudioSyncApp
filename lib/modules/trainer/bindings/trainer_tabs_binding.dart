import 'package:get/get.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_lessons_controller.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/trainer_lessons_service.dart';
import 'package:studiosync/shared/controllers/tabs_controller.dart';
import 'package:studiosync/modules/trainer/contollers/trainees_controller.dart';
import 'package:studiosync/modules/trainer/features/trainees/services/trainees_service.dart';
import 'package:studiosync/modules/trainer/features/trainees/services/trainess_filter_service.dart';

class TrainerTabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TraineeListService(Get.find()));
    Get.lazyPut(() => TraineeFilterService());
    Get.lazyPut(() => TrainerLessonsService(Get.find()));
    Get.put(GeneralTabController(['Profile', 'Clients', 'Sessions']));
    Get.put(TraineesController(Get.find(), Get.find(), Get.find()));
    Get.put(TrainerLessonsController(
      trainerLessonsService: Get.find(),
      trainerController: Get.find(),
    ));
  }
}
