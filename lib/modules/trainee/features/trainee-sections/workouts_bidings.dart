import 'package:get/get.dart';
import 'package:studiosync/core/domain/usecases/fetch_workouts_usecase.dart';
import 'package:studiosync/core/domain/usecases/sort_workouts_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/data/repositories/firestore_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/get_trainee_usecase.dart';
import 'package:studiosync/core/domain/usecases/stream_workouts_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainee-sections/workouts_controller.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/workouts/data/repositories/firestore_workouts_repository.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/workouts/domain/repositories/i_workouts_repository.dart';

class WorkoutsTraineeTabBinding extends Bindings {
  @override
  void dependencies() {
    // concrete repos
    Get.lazyPut<IWorkoutRepository>(
        () => FirestoreWorkoutsRepository(firestoreService: Get.find()));
    Get.lazyPut<ITraineeRepository>(
        () => FirestoreTraineeRepository(Get.find()));
    // use cases
    Get.lazyPut(
      () => GetTraineeDataUseCasee(
          iTraineeRepository: Get.find(), iAuthRepository: Get.find()),
    );
    Get.lazyPut(() => FetchWorkoutUseCase(iWorkoutRepository: Get.find()));
    Get.lazyPut(
        () => StreamWorkoutChangesUseCase(iWorkoutRepository: Get.find()));
    Get.lazyPut(() => SortWorkoutsUseCase());

    // controllers
    Get.lazyPut(() => WorkoutTraineeController(
          fetchWorkoutsUseCase: Get.find(),
          getTraineeDataUseCasee: Get.find(),
          getWorkoutChangesUseCase: Get.find(),
          filterAndSortWorkoutsUseCase: Get.find(),
        ));
  }
}
