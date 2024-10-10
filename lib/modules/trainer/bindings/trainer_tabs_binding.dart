import 'package:get/get.dart';
import 'package:studiosync/shared/controllers/tabs_controller.dart';
import 'package:studiosync/modules/trainer/contollers/trainees_controller.dart';
import 'package:studiosync/modules/trainer/features/trainees/services/trainees_service.dart';
import 'package:studiosync/modules/trainer/features/trainees/services/trainess_filter_service.dart';

class TrainerTabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TraineeListService(Get.find()));
    Get.lazyPut(() => TraineeFilterService());
    Get.put(GeneralTabController(['Profile', 'Clients', 'Sessions']));
    Get.put(TraineesController(Get.find(), Get.find(), Get.find()));
  }
}
