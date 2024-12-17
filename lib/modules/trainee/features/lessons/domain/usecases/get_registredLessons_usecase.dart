import 'package:studiosync/modules/trainee/features/lessons/domain/repositories/i_registredLessons_repository.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';

class GetRegisteredLessonsUseCase {
  final IRegistredLessonsRepository _repository;

  GetRegisteredLessonsUseCase({required IRegistredLessonsRepository repository}) : _repository = repository;

  Stream<List<LessonModel>>call(String trainerId, String traineeId)  {
    return _repository.getRegisteredLessons(trainerId, traineeId);
  }
}

