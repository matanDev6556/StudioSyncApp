import 'package:flutter/material.dart';
import 'package:studiosync/core/domain/repositories/i_lessons_repository.dart';

class DeleteLessonUseCase {
  final ILessonsRepository _iLessonsRepository;

  DeleteLessonUseCase({required ILessonsRepository iLessonsRepository})
      : _iLessonsRepository = iLessonsRepository;

  Future<void> call(String trainerId, String lessonId) async {
    try {
      await _iLessonsRepository.deleteLesson(trainerId, lessonId);
    } catch (e) {
      debugPrint('error from delete lesson use case: $e');
      throw Exception('error delete lesson');
    }
  }
}
