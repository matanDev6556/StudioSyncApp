import 'package:flutter/widgets.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/repositories/i_lessons_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_trainee_repository.dart';

class JoinLessonUseCase {
  final ILessonsTraineeRepository _repository;
  final ITraineeRepository _traineeRepository;

  JoinLessonUseCase(
      {required ILessonsTraineeRepository repository,
      required ITraineeRepository iTraineeRepository})
      : _repository = repository,
        _traineeRepository = iTraineeRepository;

  Future<void> call(
      String trainerId, String lessonId, TraineeModel traineeModel) async {
    try {
      if (traineeModel.subscription != null &&
          traineeModel.subscription!.isAllowedTosheduleLesson()) {
        await _repository.addTraineeToLesson(
           trainerId, lessonId, traineeModel.userId);

        await _traineeRepository.saveTrainee(traineeModel);
      }
    } catch (e) {
      debugPrint("Error joining lesson from use case : $e");
    }
  }
}
