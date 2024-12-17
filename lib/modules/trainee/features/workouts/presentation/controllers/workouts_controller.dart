import 'dart:async';
import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/workouts/domain/usecases/fetch_workouts_usecase.dart';
import 'package:studiosync/modules/trainee/features/workouts/domain/usecases/listen_workouts_usecase.dart';
import 'package:studiosync/modules/trainee/features/workouts/domain/usecases/sort_workouts_usecase.dart';
import 'package:studiosync/modules/trainee/models/workout_model.dart';
import 'package:studiosync/shared/models/workout_summary.dart';
import 'package:studiosync/shared/services/workouts_analytics_service.dart';

class WorkoutController extends GetxController {
  final FetchWorkoutsUseCase fetchWorkoutsUseCase;
  final ListenWorkoutChangesUseCase getWorkoutChangesUseCase;
  final SortWorkoutsUseCase filterAndSortWorkoutsUseCase;

  final TraineeController traineeController = Get.find();

  WorkoutController({
    required this.fetchWorkoutsUseCase,
    required this.getWorkoutChangesUseCase,
    required this.filterAndSortWorkoutsUseCase,
  });

  RxList<WorkoutModel> workouts = <WorkoutModel>[].obs;
  late StreamSubscription<List<WorkoutModel>> workoutsDocSubscription;

  Rx<WorkoutSummary> get workoutSummary =>
      Rx<WorkoutSummary>(WorkoutAnalytics.computeWorkoutSummary(workouts));

  @override
  void onInit() {
    super.onInit();
    _listenToWorkoutChanges();
  }

  void _listenToWorkoutChanges() {
    final trainee = traineeController.trainee.value;
    if (trainee != null) {
      workoutsDocSubscription = getWorkoutChangesUseCase.execute(
        trainee.trainerID,
        trainee.userId,
      ).listen((updatedWorkouts) {
        workouts.assignAll(filterAndSortWorkoutsUseCase(updatedWorkouts));
      });
    }
  }

  Future<void> fetchWorkouts() async {
    final trainee = traineeController.trainee.value;
    if (trainee != null) {
      final workoutsList = await fetchWorkoutsUseCase.execute(
        trainee.trainerID,
        trainee.userId,
      );
      workouts.assignAll(filterAndSortWorkoutsUseCase(workoutsList));
    }
  }



  @override
  void onClose() {
    workoutsDocSubscription.cancel();
    super.onClose();
  }
}