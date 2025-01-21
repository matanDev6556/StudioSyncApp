import 'package:studiosync/core/domain/repositories/i_lessons_repository.dart';
import 'package:studiosync/modules/lessons/data/model/lesson_model.dart';

class StreamTraineeLessonsUseCase {
  final ILessonsRepository _iLessonsRepository;

  StreamTraineeLessonsUseCase({required ILessonsRepository iLessonsRepository})
      : _iLessonsRepository = iLessonsRepository;

  Stream<List<LessonModel>> call(String trainerId,String traineeId) {
    return _iLessonsRepository.streamRegisteredTraineeLessons(trainerId,traineeId);
  }
}
