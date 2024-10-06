import 'package:get/get.dart';
import 'package:studiosync/modules/trainer/contollers/trainees_controller.dart';

class TrainerTabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TraineesController(Get.find(), Get.find()));
  }
}
