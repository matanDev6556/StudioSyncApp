import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:studiosync/modules/workouts/domain/usecases/fetch_workouts_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/get_trainee_usecase.dart';
import 'package:studiosync/modules/workouts/domain/usecases/stream_workouts_usecase.dart';
import 'package:studiosync/modules/workouts/domain/usecases/sort_workouts_usecase.dart';
import 'package:studiosync/modules/workouts/data/model/workout_model.dart';
import 'package:studiosync/modules/workouts/data/model/workout_summary.dart';
import 'package:studiosync/core/analytics/workouts_analytics.dart';

class WorkoutTraineeController extends GetxController {
  final FetchWorkoutUseCase fetchWorkoutsUseCase;
  final StreamWorkoutChangesUseCase getWorkoutChangesUseCase;
  final SortWorkoutsUseCase filterAndSortWorkoutsUseCase;
  final GetTraineeDataUseCasee getTraineeDataUseCasee;

  late TraineeModel? trainee;

  WorkoutTraineeController({
    required this.fetchWorkoutsUseCase,
    required this.getWorkoutChangesUseCase,
    required this.filterAndSortWorkoutsUseCase,
    required this.getTraineeDataUseCasee,
  });

  RxList<WorkoutModel> workouts = <WorkoutModel>[].obs;
  late StreamSubscription<List<WorkoutModel>> workoutsDocSubscription;

  Rx<WorkoutSummary> get workoutSummary =>
      Rx<WorkoutSummary>(WorkoutAnalytics.computeWorkoutSummary(workouts));

  @override
  void onInit() async {
    super.onInit();

    await fetchTrainee();

    if (trainee != null) {
      _listenToWorkoutChanges();
    } else {
      debugPrint("Trainee data is not available.");
    }
  }

  @override
  void onClose() {
    print('dispose..');
    workoutsDocSubscription.cancel();
    super.onClose();
  }

  Future<void> fetchTrainee() async {
    trainee = await getTraineeDataUseCasee();
  }

  void _listenToWorkoutChanges() {
    if (trainee == null) {
      debugPrint("Trainee is null. Cannot listen to workout changes.");
      return;
    }
    debugPrint("listen to workout changes.");
    workoutsDocSubscription = getWorkoutChangesUseCase(
      trainee!.trainerID,
      trainee!.userId,
    ).listen((updatedWorkouts) {
      debugPrint("listen to workout changes $updatedWorkouts");
      workouts.assignAll(filterAndSortWorkoutsUseCase(updatedWorkouts));
    });
  }

  Future<void> fetchWorkouts() async {
    if (trainee != null) {
      final workoutsList = await fetchWorkoutsUseCase(
        trainee!.trainerID,
        trainee!.userId,
      );
      workouts.assignAll(filterAndSortWorkoutsUseCase(workoutsList));
    }
  }
}
