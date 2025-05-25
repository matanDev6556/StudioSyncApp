import 'package:get/get.dart';
import 'package:studiosync/modules/lessons/presentation/bindings/trainee_lessons_binding.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/bindings/trainee_binding.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/presentation/bindings/profile_trainer_binding.dart';
import 'package:studiosync/modules/workouts/presentation/bindings/trainee_workouts_bindings.dart';

class TraineeTabsBinding extends Bindings {
  @override
  void dependencies() {

    TraineeBinding().dependencies();

    //spetsific tabs dep

    ProfileTraineeTabBinding().dependencies();
    WorkoutsTraineeBindings().dependencies();
    LessonsTraineeBinding().dependencies();
  }
}
