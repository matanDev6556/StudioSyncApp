import 'package:flutter/widgets.dart';
import 'package:studiosync/core/domain/repositories/i_lessons_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_trainee_repository.dart';

class CancelLessonUseCase {
  final ILessonsRepository _iLessonRepository;
  final ITraineeRepository _iTraineeRepository;

  CancelLessonUseCase({
    required ILessonsRepository iLessonRepository,
    required ITraineeRepository iTraineeRepository,
  })  : _iLessonRepository = iLessonRepository,
        _iTraineeRepository = iTraineeRepository;

  Future<void> call(
      String trainerId, String lessonId, TraineeModel traineeModel) async {
    try {
      await _iLessonRepository.removeTraineeFromLesson(
          trainerId, lessonId, traineeModel.userId);
      // change the sub
      traineeModel.subscription?.cancleLesson();
      await _iTraineeRepository.saveTrainee(traineeModel);
    } catch (e) {
      debugPrint("error from cancle lesson use case $e");
      throw Exception("Error in canceling lesson: $e");
    }
  }
}
