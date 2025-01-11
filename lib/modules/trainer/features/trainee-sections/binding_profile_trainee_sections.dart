import 'package:get/get.dart';
import 'package:studiosync/modules/trainer/features/trainee-sections/subscription/presentation/subscription_binding.dart';
import 'package:studiosync/modules/workouts/presentation/bindings/trainer_workouts_binding.dart';

class TraineeProfileBinding extends Bindings {
  @override
  void dependencies() {
    WorkoutsTrainerBindings().dependencies();
    SubscriptionBindings().dependencies();
  }
}
