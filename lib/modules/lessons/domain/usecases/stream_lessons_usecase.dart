import 'package:studiosync/core/domain/repositories/i_lessons_repository.dart';
import 'package:studiosync/modules/lessons/data/model/lesson_model.dart';

class StreamLessonsUseCase {
  final ILessonsRepository _iLessonsRepository;

  StreamLessonsUseCase({required ILessonsRepository iLessonsRepository})
      : _iLessonsRepository = iLessonsRepository;

  Stream<List<LessonModel>> call(String trainerId) {
    return _iLessonsRepository.streamLessons(trainerId);
  }
}
