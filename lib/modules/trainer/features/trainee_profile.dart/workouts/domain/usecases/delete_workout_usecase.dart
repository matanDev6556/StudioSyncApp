import 'package:flutter/material.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/workouts/data/models/workout_model.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/workouts/domain/repositories/i_workouts_repository.dart';

class DeleteWorkoutUseCase {
  final IWorkoutRepository _iWorkoutRepository;

  DeleteWorkoutUseCase({required IWorkoutRepository iWorkoutRepository})
      : _iWorkoutRepository = iWorkoutRepository;

  Future<void> call(
    String trainerId,
    TraineeModel traineeModel,
     WorkoutModel workout,
  ) async {
    try {
      await _iWorkoutRepository.deleteWorkout(
          trainerId, traineeModel,workout);
    } catch (e) {
      debugPrint('error delete workout use case : $e');
    }
  }
}
