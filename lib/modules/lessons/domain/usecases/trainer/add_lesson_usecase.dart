import 'package:flutter/material.dart';
import 'package:studiosync/core/domain/repositories/i_lessons_repository.dart';
import 'package:studiosync/modules/lessons/data/model/lesson_model.dart';

class AddLessonUseCase {
  final ILessonsRepository _iLessonsRepository;

  AddLessonUseCase({required ILessonsRepository iLessonsRepository})
      : _iLessonsRepository = iLessonsRepository;

  Future<void> call(String trainerId, LessonModel lesson) async {
    try {
      await _iLessonsRepository.addLesson(trainerId, lesson);
    } catch (e) {
      debugPrint('Error from add lesson use case: $e');
      throw Exception('Error adding lesson');
    }
  }
}
