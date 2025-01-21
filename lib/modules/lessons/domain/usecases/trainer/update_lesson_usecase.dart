import 'package:flutter/material.dart';
import 'package:studiosync/core/domain/repositories/i_lessons_repository.dart';
import 'package:studiosync/modules/lessons/data/model/lesson_model.dart';

class UpdateLessonUseCase {
  final ILessonsRepository _iLessonsRepository;

  UpdateLessonUseCase({required ILessonsRepository iLessonsRepository})
      : _iLessonsRepository = iLessonsRepository;

  Future<void> call(String trainerId, LessonModel lesson) async {
    try {
      await _iLessonsRepository.updateLesson(trainerId, lesson);
    } catch (e) {
      debugPrint('error from update lesson use case $e');
    }
  }
}
