import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';

abstract class IRegistredLessonsRepository {
  Stream<List<LessonModel>> getRegisteredLessons(
      String trainerId, String traineeId);
}
