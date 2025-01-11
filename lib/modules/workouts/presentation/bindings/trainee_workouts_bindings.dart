import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/get_trainee_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainee-sections/workouts_controller.dart';
import 'package:studiosync/modules/workouts/domain/usecases/fetch_workouts_usecase.dart';
import 'package:studiosync/modules/workouts/domain/usecases/sort_workouts_usecase.dart';

class WorkoutsTraineeBindings implements Bindings {
  @override
  void dependencies() {
    
    // use cases
    Get.lazyPut(
      () => GetTraineeDataUseCasee(
          iTraineeRepository: Get.find(), iAuthRepository: Get.find()),
    );
    Get.lazyPut(() => FetchWorkoutUseCase(iWorkoutRepository: Get.find()));

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
