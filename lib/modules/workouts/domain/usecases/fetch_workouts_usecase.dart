import 'package:flutter/material.dart';
import 'package:studiosync/modules/workouts/data/model/workout_model.dart';
import 'package:studiosync/modules/workouts/domain/repository/i_workouts_repository.dart';

class FetchWorkoutUseCase {
  final IWorkoutRepository _iWorkoutRepository;

  FetchWorkoutUseCase({required IWorkoutRepository iWorkoutRepository})
      : _iWorkoutRepository = iWorkoutRepository;

 Future<List<WorkoutModel>> call(String trainerId, String traineeId) async {
    try {
      return await _iWorkoutRepository.fetchWorkouts(trainerId, traineeId);
    } catch (e) {
      debugPrint('error fetch workouts use case : $e');
      return [];
    }
  }
}
