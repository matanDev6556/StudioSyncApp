import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/controllers/lessons_upcoming_controller.dart';
import 'package:studiosync/modules/trainee/controllers/trainer_profile_controller.dart';
import 'package:studiosync/modules/trainee/controllers/workouts_controller.dart';
import 'package:studiosync/modules/trainee/features/lessons/service/upcoming_lessons_service.dart';
import 'package:studiosync/modules/trainee/features/workouts/services/workouts_service.dart';
import 'package:studiosync/shared/controllers/tabs_controller.dart';

class TraineeTabsBinding extends Bindings {
  @override
  void dependencies() {
    // general dep
    Get.put(GeneralTabController([
      'Profile',
      'Workouts',
      'Sessions',
    ]));

    //spetsific tabs dep
    _bindProfileTab();
    _bindWorkoutsTab();
    _bindLessonsTab();
  }

  void _bindProfileTab() {
    Get.lazyPut(() => TrainerProfileController(firestoreService: Get.find()));
  }

  void _bindWorkoutsTab() {
    Get.lazyPut(() => WorkoutsService(firestoreService: Get.find()));
    Get.lazyPut(() => WorkoutController(workoutsService: Get.find()));
  }

  void _bindLessonsTab() {
    Get.lazyPut(
        () => UpcomingLessonsTraineeService(firestoreService: Get.find()));
    Get.put(
        UpcomingLessonsController(upcomingLessonsTraineeService: Get.find()));
  }
}
