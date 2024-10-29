import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/models/workout_model.dart';
import 'package:studiosync/modules/trainer/contollers/workout_form_handler.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/services/trainee_profile_service.dart';
import 'package:studiosync/shared/services/workouts_analytics_service.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/widgets/add_edit_workout_buttom.dart';
import 'package:studiosync/shared/models/workout_summary.dart';

// handle the spetsific trainee profile for add\edit\delete workouts

class TraineeWorkoutController extends GetxController {
  final TraineeProfileService traineeProfileService;

  TraineeWorkoutController({
    required TraineeModel initialTrainee,
    required this.traineeProfileService,
  }) {
    trainee.value = initialTrainee;
  }

  final Rx<TraineeModel?> trainee = Rx<TraineeModel?>(null);
  RxList<WorkoutModel> workouts = <WorkoutModel>[].obs;
  late StreamSubscription<TraineeModel> traineeDocSubscription;
  late StreamSubscription<List<WorkoutModel>> workoutsDocSubscription;
  final WorkoutFormHandler workoutFormHandler = WorkoutFormHandler();

  @override
  void onInit() {
    super.onInit();
    _listenToTraineeChanges();
    _listenToWorkoutChanges();
  }

  @override
  void onReady() {
    super.onReady();
    fetchWorkouts();
  }

  //-----------TRAINEE------------

  void _listenToTraineeChanges() {
    if (trainee.value != null) {
      traineeDocSubscription = traineeProfileService
          .getTraineeChanges(trainee.value!.trainerID, trainee.value!.userId)
          .listen((updatedTrainee) {
        trainee.value = updatedTrainee;
        updateLocalTrainee(updatedTrainee);
      });
    }
  }

  void deleteTrainee() {
    // Implement delete logic here
  }

  void updateLocalTrainee(TraineeModel updatedTrainee) {
    trainee.value = updatedTrainee;
    trainee.refresh();
  }

  //-----------WORKOUTS------------
  void _listenToWorkoutChanges() {
    if (trainee.value != null) {
      workoutsDocSubscription = traineeProfileService
          .getWorkoutChanges(trainee.value!.trainerID, trainee.value!.userId)
          .listen((updatedWorkouts) {
        workouts.value = updatedWorkouts;
      });
    }
  }

  Future<void> fetchWorkouts() async {
    if (trainee.value != null) {
      final workoutsList = await traineeProfileService.fetchWorkouts(
          trainee.value!.trainerID, trainee.value!.userId);

      // Convert date strings to DateTime objects and sort by date in descending order (latest first)
      workouts.value = workoutsList
        ..sort((a, b) {
          DateTime dateA = DateTime.parse(a.dateScope.toString());
          DateTime dateB = DateTime.parse(b.dateScope.toString());
          return dateB.compareTo(dateA); // Descending order
        });
    }
  }

  void addWorkout() {
    if (!workoutFormHandler.validateWorkoutInput()) return;

    final newWorkout = workoutFormHandler.createWorkoutFromInput();
    workouts.add(newWorkout);
    traineeProfileService.addWorkoutToTrainee(
      trainee.value!.trainerID,
      trainee.value!.userId,
      newWorkout,
    );

    Get.back();
    Get.snackbar('Success', 'Workout added successfully',
        backgroundColor: Colors.greenAccent, colorText: Colors.white);

    workoutFormHandler.resetControllers();
  }

  void deleteWorkout(WorkoutModel workout) async {
    await traineeProfileService.deleteWorkout(
        trainee.value!.trainerID, trainee.value!, workout);
    workouts.value = List.from(workouts)..remove(workout);
    workouts.refresh();
  }

  void updateWorkout(WorkoutModel? workout) async {
    final updatedWorkout = workout?.copyWith(
      weight: double.parse(workoutFormHandler.weightController.text),
      listScopes: workoutFormHandler.createScopesFromInput(),
    );

    await traineeProfileService.editWorkoutToFirestore(
      trainee.value!.trainerID,
      trainee.value!,
      updatedWorkout!,
    );

    Get.back();
  }

  void showAddWorkoutBottomSheet(WorkoutModel? workout) {
    Get.bottomSheet(
      AddEditWorkoutBottomSheet(workout: workout, trainee: trainee.value),
      isScrollControlled: true,
    );
    workoutFormHandler.resetControllers();
  }

  String getFormattedStartDate() {
    return trainee.value?.startWorOutDate != null
        ? DateFormat('yMMMMd').format(trainee.value!.startWorOutDate!)
        : 'Not start yet';
  }

  //----Statistics----

  Rx<WorkoutSummary> get workoutSummary =>
      Rx<WorkoutSummary>(WorkoutAnalytics.computeWorkoutSummary(workouts));

  @override
  void onClose() {
    traineeDocSubscription.cancel();
    super.onClose();
  }
}
