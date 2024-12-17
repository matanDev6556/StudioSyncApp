import 'package:flutter/foundation.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/repositories/i_lessons_trainee_repository.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';

class GetUpcomingLessonsUseCase {
  final ILessonsTraineeRepository _repository;

  GetUpcomingLessonsUseCase({required ILessonsTraineeRepository repository})
      : _repository = repository;

  Stream<List<LessonModel>> call(String trainerId) {
    try {
      return _repository.getUpcomingLessons(trainerId);
    } catch (e) {
      debugPrint("Error from get upcoming lessons use case: $e");
      return Stream.value([]);
    }
  }
}
