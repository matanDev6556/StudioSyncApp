import 'package:get/get.dart';
import 'package:studiosync/modules/workouts/domain/repository/i_workouts_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/repositories/firestore_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/listen_trainee_updates_use_case.dart';
import 'package:studiosync/modules/workouts/data/repository/workouts_firestore_repository.dart';
import 'package:studiosync/modules/workouts/domain/usecases/trainer/add_workout_usecase.dart';
import 'package:studiosync/modules/workouts/domain/usecases/trainer/delete_workout_usecase.dart';
import 'package:studiosync/modules/workouts/domain/usecases/trainer/edit_workout_usecase.dart';
import 'package:studiosync/modules/workouts/domain/usecases/fetch_workouts_usecase.dart';
import 'package:studiosync/modules/trainer/features/trainee-sections/workouts/presentation/workouts_controller.dart';

class WorkoutsTrainerBindings implements Bindings {
  @override
  void dependencies() {
   // concrete repos
    Get.put<IWorkoutRepository>(
        FirestoreWorkoutsRepository(firestoreService: Get.find()));

    Get.put<ITraineeRepository>(FirestoreTraineeRepository(firestoreService: Get.find()));
    // use cases
    Get.lazyPut(() => ListenToTraineeUpdatesUseCase(iTraineeRepository: Get.find()));

   
    Get.lazyPut(() => FetchWorkoutUseCase(iWorkoutRepository: Get.find()));
    Get.lazyPut(() => AddWorkoutUseCase(iWorkoutRepository: Get.find()));
    Get.lazyPut(() => EditWorkoutUseCase(iWorkoutRepository: Get.find()));
    Get.lazyPut(() => DeleteWorkoutUseCase(iWorkoutRepository: Get.find()));

    // controlelrs
    Get.put(
      WorkoutsController(
        fetchWorkoutUseCase: Get.find(),
        addWorkoutUseCase: Get.find(),
        editWorkoutUseCase: Get.find(),
        deleteWorkoutUseCase: Get.find(),
      ),
    );

  }
  
}
