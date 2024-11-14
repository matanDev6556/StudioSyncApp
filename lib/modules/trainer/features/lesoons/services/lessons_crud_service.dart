// lessons_crud_service.dart
import 'package:studiosync/modules/trainer/features/lesoons/services/trainer_lessons_service.dart';
import 'package:uuid/uuid.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';
import 'package:studiosync/core/utils/dates.dart';

class LessonsCrudService {
  final TrainerLessonsService trainerLessonsService;

  LessonsCrudService({required this.trainerLessonsService});

  Future<void> addLesson(String trainerId, LessonModel lesson) async {
    try {
      final newLesson = lesson.copyWith(
        id: const Uuid().v4(),
        trainerID: trainerId,
        day: DatesUtils.getDayFromIndex(lesson.startDateTime.day),
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


  bool validateLesson(LessonModel? lesson) {
    if (lesson == null) return false;

    if (lesson.typeLesson.isEmpty) {
      throw Exception('Type is required!');
    }
    if (lesson.location.isEmpty) {
      throw Exception('Location is required!');
    }
    if (lesson.trainerName.isEmpty) {
      throw Exception('Trainer name is required!');
    }

    return true;
  }
}
