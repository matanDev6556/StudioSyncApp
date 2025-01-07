import 'package:flutter/widgets.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/repositories/i_lessons_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_trainee_repository.dart';

class CancelLessonUseCase {
  final ILessonsTraineeRepository _repository;
  final ITraineeRepository _traineeRepository;

  CancelLessonUseCase(
      {required ILessonsTraineeRepository repository,
      required ITraineeRepository iTraineeRepository})
      : _repository = repository,
        _traineeRepository = iTraineeRepository;

  Future<void> call(
      String trainerId, String lessonId, TraineeModel traineeModel) async {
    try {
      await _repository.removeTraineeFromLesson(
          trainerId, lessonId, traineeModel.userId);
      traineeModel.subscription?.cancleLesson();
      await _traineeRepository.saveTrainee(traineeModel);
    } catch (e) {
      debugPrint("שגיאה בביטול השיעור: $e");
    }
  }
}
