import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/features/lessons/data/repositories/lessons_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/lessons/data/repositories/registred_lessons_repository.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/repositories/i_lessons_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/repositories/i_registredLessons_repository.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/cancle_lesson_usecase.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/get_registredLessons_usecase.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/controllers/lessons_upcoming_controller.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/bindings/trainee_binding.dart';
import 'package:studiosync/modules/trainee/features/workouts/data/repositories/firestore_workouts_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/workouts/domain/repositories/i_workouts_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/workouts/domain/usecases/fetch_workouts_usecase.dart';
import 'package:studiosync/modules/trainee/features/workouts/domain/usecases/listen_workouts_usecase.dart';
import 'package:studiosync/modules/trainee/features/workouts/domain/usecases/sort_workouts_usecase.dart';
import 'package:studiosync/modules/trainee/features/workouts/presentation/controllers/workouts_controller.dart';
import 'package:studiosync/modules/trainee/features/profile/data/repositories/firestore_mytrainer_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_mytrainer_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/fetch_mytrainer_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/my_trainer_controller.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/disconnect_trainer_ussecase.dart';
import 'package:studiosync/core/presentation/controllers/tabs_controller.dart';

class TraineeTabsBinding extends Bindings {
  @override
  void dependencies() {
    TraineeBinding().dependencies();
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
    Get.lazyPut<IWorkoutsRepository>(
        () => WorkoutsRepositoryFirestore(firestoreService: Get.find()));
    Get.lazyPut(() => FetchWorkoutsUseCase(repository: Get.find()));
    Get.lazyPut(() => ListenWorkoutChangesUseCase(repository: Get.find()));
    Get.lazyPut(() => SortWorkoutsUseCase());

    Get.lazyPut(() => WorkoutController(
          fetchWorkoutsUseCase: Get.find(),
          getWorkoutChangesUseCase: Get.find(),
          filterAndSortWorkoutsUseCase: Get.find(),
        ));
  }

  void _bindLessonsTab() {
    Get.lazyPut<ILessonsTraineeRepository>(
        () => LessonsTraineeRepsitory(firestoreService: Get.find()));
    Get.lazyPut<IRegistredLessonsRepository>(
      () => RegistredTraineeLessonsFirestoreRepository(
          firestoreService: Get.find()),
    );
    Get.lazyPut(() => CancelLessonUseCase(repository: Get.find()));
    Get.lazyPut(() => GetRegisteredLessonsUseCase(repository: Get.find()));

    Get.lazyPut(
      () => UpcomingLessonsController(
        cancelLessonUseCase: Get.find(),
        getRegisteredLessonsUseCase: Get.find(),
      ),
    );
  }
}

class ProfileTraineeTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<IMyTrainerRepositroy>(MyTrainerFirestoreRepository(Get.find()));
    // use cases
    Get.lazyPut(() =>
        DisconnectTrainerUseCase(repository: Get.find<IMyTrainerRepositroy>()));
    Get.lazyPut(() => FetchMyTrainerUseCase(Get.find<IMyTrainerRepositroy>()));
    //controller
    Get.put(MyTrainerController(
      disconnectTrainerUseCase: Get.find(),
      fetchMyTrainerUseCase: Get.find(),
    ));
  }
}

class WorkoutsTraineeTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IWorkoutsRepository>(
        () => WorkoutsRepositoryFirestore(firestoreService: Get.find()));
    Get.lazyPut(() => FetchWorkoutsUseCase(repository: Get.find()));
    Get.lazyPut(() => ListenWorkoutChangesUseCase(repository: Get.find()));
    Get.lazyPut(() => SortWorkoutsUseCase());

    Get.lazyPut(() => WorkoutController(
          fetchWorkoutsUseCase: Get.find(),
          getWorkoutChangesUseCase: Get.find(),
          filterAndSortWorkoutsUseCase: Get.find(),
        ));
  }
}

class LessonsTraineeTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ILessonsTraineeRepository>(
        () => LessonsTraineeRepsitory(firestoreService: Get.find()));
    Get.lazyPut<IRegistredLessonsRepository>(
      () => RegistredTraineeLessonsFirestoreRepository(
          firestoreService: Get.find()),
    );
    Get.lazyPut(() => CancelLessonUseCase(repository: Get.find()));
    Get.lazyPut(() => GetRegisteredLessonsUseCase(repository: Get.find()));

    Get.lazyPut(
      () => UpcomingLessonsController(
        cancelLessonUseCase: Get.find(),
        getRegisteredLessonsUseCase: Get.find(),
      ),
    );
  }
}
