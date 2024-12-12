import 'package:get/get.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/controllers/lessons_upcoming_controller.dart';
import 'package:studiosync/modules/trainee/controllers/trainer_profile_controller.dart';
import 'package:studiosync/modules/trainee/controllers/trainers_list_try_controller.dart';
import 'package:studiosync/modules/trainee/controllers/workouts_controller.dart';
import 'package:studiosync/modules/trainee/features/lessons/service/upcoming_lessons_service.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/repositories/firesstore_trainers_list_repository.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/usecases/fetch_trainers_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/usecases/filter_trainers_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/usecases/load_prefrences_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/usecases/save_preference_usecase.dart';
import 'package:studiosync/modules/trainee/features/workouts/services/workouts_service.dart';
import 'package:studiosync/shared/controllers/tabs_controller.dart';
import 'package:studiosync/shared/repositories/interfaces/local_storage_repository.dart';

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
    final firestoreService = Get.find<FirestoreService>();
    Get.lazyPut(
        () => TrainerProfileController(firestoreService: firestoreService));
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
