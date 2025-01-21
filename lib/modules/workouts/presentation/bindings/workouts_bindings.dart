import 'package:get/get.dart';
import 'package:studiosync/modules/workouts/data/repository/workouts_firestore_repository.dart';
import 'package:studiosync/modules/workouts/domain/repository/i_workouts_repository.dart';
import 'package:studiosync/modules/workouts/domain/usecases/stream_workouts_usecase.dart';

class WorkoutsBindings implements Bindings {
  @override
  void dependencies() {
    //  concrete repos
    Get.lazyPut<IWorkoutRepository>(
        () => FirestoreWorkoutsRepository(firestoreService: Get.find()));

    // coomon use case
    Get.lazyPut(
        () => StreamWorkoutChangesUseCase(iWorkoutRepository: Get.find()));
  }
}
