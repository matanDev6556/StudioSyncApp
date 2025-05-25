import 'dart:async';
import 'package:flutter/material.dart';
import 'package:studiosync/modules/workouts/data/model/workout_summary.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/trainee-sections/workouts/presentation/widgets/add_edit_workout_buttom.dart';
import 'package:studiosync/modules/trainer/features/trainee-sections/workouts/presentation/workout_form_handler.dart';
import 'package:studiosync/modules/workouts/data/model/workout_model.dart';
import 'package:studiosync/modules/workouts/domain/usecases/trainer/add_workout_usecase.dart';
import 'package:studiosync/modules/workouts/domain/usecases/trainer/delete_workout_usecase.dart';
import 'package:studiosync/modules/workouts/domain/usecases/trainer/edit_workout_usecase.dart';
import 'package:studiosync/modules/workouts/domain/usecases/fetch_workouts_usecase.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/analytics/workouts_analytics.dart';

class WorkoutsController extends GetxController {
  final FetchWorkoutUseCase fetchWorkoutUseCase;
  final AddWorkoutUseCase addWorkoutUseCase;
  final EditWorkoutUseCase editWorkoutUseCase;
  final DeleteWorkoutUseCase deleteWorkoutUseCase;

  WorkoutsController({
    required this.fetchWorkoutUseCase,
    required this.addWorkoutUseCase,
    required this.editWorkoutUseCase,
    required this.deleteWorkoutUseCase,
  });

  final WorkoutFormHandler workoutFormHandler = WorkoutFormHandler();

  RxList<WorkoutModel> workouts = <WorkoutModel>[].obs;
  Rx<WorkoutSummary> get workoutSummary =>
      Rx<WorkoutSummary>(WorkoutAnalytics.computeWorkoutSummary(workouts));

  Future<void> fetchWorkouts(TraineeModel traineeModel) async {
    if (workouts.isEmpty) {
      final workoutsList = await fetchWorkoutUseCase(
          traineeModel.trainerID, traineeModel.userId);
      workouts.assignAll(_filterAndSortWorkoutsByDate(workoutsList));
    }
  }

  void addWorkout(TraineeModel traineeModel) {
    if (!workoutFormHandler.validateWorkoutInput()) return;

    final newWorkout = workoutFormHandler.createWorkoutFromInput();
    workouts.add(newWorkout); 

    addWorkoutUseCase(
      traineeModel.trainerID,
      traineeModel.userId,
      newWorkout,
    );
    Get.back();
    Get.snackbar(
      'Success',
      'Workout added successfully',
      backgroundColor: Colors.greenAccent,
      colorText: Colors.white,
    );
    workoutFormHandler.resetControllers();
  }

  void deleteWorkout(TraineeModel traineeModel, WorkoutModel workout) async {
    await deleteWorkoutUseCase(
      traineeModel.trainerID,
      traineeModel,
      workout,
    );
    workouts.value = List.from(workouts)..remove(workout);
    workouts.refresh();
    Get.snackbar(
      'Success',
      'Workout deleted successfully',
      backgroundColor: Colors.greenAccent,
      colorText: Colors.white,
    );
  }

  void updateWorkout(TraineeModel traineeModel, WorkoutModel? workout) async {
    final updatedWorkout = workout?.copyWith(
      weight: double.parse(workoutFormHandler.weightController.text),
      listScopes: workoutFormHandler.createScopesFromInput(),
    );

    await editWorkoutUseCase(
      traineeModel.trainerID,
      traineeModel.userId,
      updatedWorkout!,
    );

    final index = workouts.indexWhere((w) => w.id == updatedWorkout.id);
    if (index != -1) {
      workouts[index] = updatedWorkout;
      workouts.refresh(); // רענון הרשימה
    }

    Get.snackbar(
      'Success',
      'Workout updated successfully',
      backgroundColor: Colors.greenAccent,
      colorText: Colors.white,
    );
    Get.back();
  }

  void showAddWorkoutBottomSheet(
      WorkoutModel? workout, TraineeModel traineeModel) {
    Get.bottomSheet(
      AddEditWorkoutBottomSheet(workout: workout, trainee: traineeModel),
      isScrollControlled: true,
    );
    workoutFormHandler.resetControllers();
  }

  List<WorkoutModel> _filterAndSortWorkoutsByDate(
      List<WorkoutModel> workoutsList) {
    return workoutsList
      ..sort((a, b) {
        DateTime dateA = DateTime.parse(a.dateScope.toString());
        DateTime dateB = DateTime.parse(b.dateScope.toString());
        return dateB.compareTo(dateA);
      });
  }
}
