import 'package:flutter/widgets.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/repositories/i_lessons_trainee_repository.dart';

class CancelLessonUseCase {
  final ILessonsTraineeRepository _repository;

  CancelLessonUseCase({required ILessonsTraineeRepository repository}) : _repository = repository;

  Future<void> call(String trainerId, String lessonId, String traineeId) async {
    try {
      await _repository.removeTraineeFromLesson(trainerId, lessonId, traineeId);
    } catch (e) {
      debugPrint("שגיאה בביטול השיעור: $e");
    }
  }
}