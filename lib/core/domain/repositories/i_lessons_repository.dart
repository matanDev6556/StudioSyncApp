import 'package:studiosync/modules/lessons/data/model/lessons_settings_model.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/lessons/data/model/lesson_model.dart';


abstract class ILessonsRepository {
  // trainer
  Future<void> addLesson(String trainerId, LessonModel lesson);
  Future<void> updateLesson(String trainerId, LessonModel lesson);
  Future<void> deleteLesson(String trainerId, String lessonId);
  Future<List<TraineeModel>> getRegisteredTraineesOfLesson(
      String trainerId, List<String> traineeIds);
  // lessons settings
  Future<LessonsSettingsModel> getSettingsLessons(String trainerId);
  Future<void> updateSettingsLessons(String trainerId,LessonsSettingsModel lessonsSettingsModel);

  // trainee
  Future<void> addTraineeToLesson(
      TraineeModel traineeModel, String lessonId);
  Future<void> removeTraineeFromLesson(
      String trainerId, String lessonId, String traineeId);
  Stream<List<LessonModel>> streamRegisteredTraineeLessons(
      String trainerId, String traineeId);

  // common
  Stream<List<LessonModel>> streamLessons(String trainerID);
  Stream<LessonsSettingsModel?> streamLessonsSettings(String trainerId);
}
