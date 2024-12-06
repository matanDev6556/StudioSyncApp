// lessons_crud_service.dart

import 'package:studiosync/modules/trainer/features/lesoons/services/trainer_lessons_service.dart';
import 'package:uuid/uuid.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';


class LessonsCrudService {
  final TrainerLessonsService trainerLessonsService;

  LessonsCrudService({required this.trainerLessonsService});

  Future<void> addLesson(String trainerId, LessonModel lesson,
      {bool resetId = true}) async {
    try {
      final newLesson = lesson.copyWith(
        id: resetId ? const Uuid().v4() : lesson.id,
        trainerID: trainerId,
        traineesRegistrations: [],
      );

      await trainerLessonsService.addLesson(trainerId, newLesson);
    } catch (e) {
      throw Exception('Failed to add lesson: $e');
    }
  }

  Future<void> updateLesson(String trainerId, LessonModel lesson) async {
    try {
      await trainerLessonsService.updateLesson(trainerId, lesson);
    } catch (e) {
      throw Exception('Failed to update lesson: $e');
    }
  }

  Future<void> deleteLesson(String trainerId, String lessonId) async {
    try {
      await trainerLessonsService.deleteLesson(trainerId, lessonId);
    } catch (e) {
      throw Exception('Failed to delete lesson: $e');
    }
  }
}
