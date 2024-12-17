import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/controllers/lessons_upcoming_controller.dart';
import 'package:studiosync/modules/trainee/controllers/workouts_controller.dart';
import 'package:studiosync/modules/trainee/features/lessons/service/upcoming_lessons_service.dart';
import 'package:studiosync/modules/trainee/features/profile/data/repositories/firestore_mytrainer_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_mytrainer_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/fetch_mytrainer_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/my_trainer_controller.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/domain/usecases/disconnect_trainer_ussecase.dart';
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
    //my trainer 
    Get.put<IMyTrainerRepositroy>(MyTrainerFirestoreRepository(Get.find()));
    // use cases
    Get.lazyPut(() =>
        DisconnectTrainerUseCase(repository: Get.find<IMyTrainerRepositroy>()));
    Get.lazyPut(() => FetchMyTrainerUseCase(Get.find<IMyTrainerRepositroy>()));

    //controllers
    Get.lazyPut(() => MyTrainerController(
          disconnectTrainerUseCase: Get.find(),
          fetchMyTrainerUseCase: Get.find(),
        ));
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
