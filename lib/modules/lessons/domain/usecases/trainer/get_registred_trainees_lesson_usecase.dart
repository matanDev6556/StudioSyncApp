import 'package:flutter/material.dart';
import 'package:studiosync/core/domain/repositories/i_lessons_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

class GetRegistredTraineesOfLessonUseCase {
  final ILessonsRepository _iLessonsRepository;

  GetRegistredTraineesOfLessonUseCase(
      {required ILessonsRepository iLessonsRepository})
      : _iLessonsRepository = iLessonsRepository;

  Future<List<TraineeModel>> call(
      String trainerId, List<String> traineeIds) async {
    try {
      if (traineeIds.isNotEmpty) {
        return await _iLessonsRepository.getRegisteredTraineesOfLesson(
            trainerId, traineeIds);
      }
      return [];
    } catch (e) {
      debugPrint('error from get registred trainees of lesson use case: $e');

      return [];
    }
  }
}
