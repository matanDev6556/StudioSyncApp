import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';
import 'package:studiosync/modules/trainer/models/lessons_settings_model.dart';

abstract class ILessonsTraineeRepository {
  Stream<List<LessonModel>> getUpcomingLessons(String trainerId);
  Stream<LessonsSettingsModel?> getLessonsSettings(String trainerId);
  Future<void> addTraineeToLesson(String trainerId, String lessonId, String traineeId);
  Future<void> removeTraineeFromLesson(String trainerId, String lessonId, String traineeId);
}
