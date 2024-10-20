import 'package:get/get.dart';
import 'package:studiosync/modules/trainer/contollers/subscription_controller.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/services/trainee_profile_service.dart';

class TraineeProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TraineeProfileService(Get.find()));
    Get.lazyPut(() => SubscriptionController(Get.find()));
    //Get.lazyPut(() => TraineeWorkoutController(Get.find()));
  }
}
