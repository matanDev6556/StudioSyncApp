import 'package:flutter/material.dart';
import 'package:studiosync/modules/workouts/data/model/workout_model.dart';
import 'package:studiosync/modules/workouts/domain/repository/i_workouts_repository.dart';

class EditWorkoutUseCase {
  final IWorkoutRepository _iWorkoutRepository;

  EditWorkoutUseCase({required IWorkoutRepository iWorkoutRepository})
      : _iWorkoutRepository = iWorkoutRepository;

  Future<void> call(
    String trainerId,
    String traineeId,
    WorkoutModel workout,
  ) async {
    try {
      await _iWorkoutRepository.editWorkoutToFirestore(
          trainerId, traineeId, workout);
    } catch (e) {
      debugPrint('error edit workout use case : $e');
    }
  }
}