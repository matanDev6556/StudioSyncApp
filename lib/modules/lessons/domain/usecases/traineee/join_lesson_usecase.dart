import 'package:flutter/material.dart';
import 'package:studiosync/core/domain/repositories/i_lessons_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_trainee_repository.dart';

class JoinLessonUseCase {
  final ILessonsRepository _iLessonsRepository;
  final ITraineeRepository _iTraineeRepository;

  JoinLessonUseCase(
      {required ILessonsRepository iLessonsRepository,
      required ITraineeRepository iTraineeRepository})
      : _iLessonsRepository = iLessonsRepository,
        _iTraineeRepository = iTraineeRepository;

  Future<void> call(TraineeModel traineeModel, String lessonId) async {
    try {
      if (traineeModel.subscription?.isAllowedTosheduleLesson() ?? false) {
        traineeModel.subscription?.joinLesson();
        await _iLessonsRepository.addTraineeToLesson(traineeModel, lessonId);
        await _iTraineeRepository.saveTrainee(traineeModel);
      } else {
        throw Exception('Youre subscription expired for this month!');
      }
    } catch (e) {
      debugPrint('error from join lesson use case: $e');
      rethrow;
    }
  }
}
