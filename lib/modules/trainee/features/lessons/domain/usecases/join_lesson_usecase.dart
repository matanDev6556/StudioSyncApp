import 'package:flutter/widgets.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/repositories/i_lessons_trainee_repository.dart';

class JoinLessonUseCase {
  final ILessonsTraineeRepository _repository;

  JoinLessonUseCase({required ILessonsTraineeRepository repository}) :  _repository = repository;

  Future<void> call(String trainerId, String lessonId, String traineeId) async {
    try {
      await _repository.addTraineeToLesson(trainerId, lessonId, traineeId);
    } catch (e) {
      debugPrint("Error joining lesson: $e");
    }
  }
}