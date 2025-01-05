import 'package:get/get.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/subscription/presentation/subscription_binding.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/workouts/presentation/workouts_binding.dart';

class TraineeProfileBinding extends Bindings {
  @override
  void dependencies() {
    WorkoutsBinding().dependencies();
    SubscriptionBindings().dependencies();
  }
}
