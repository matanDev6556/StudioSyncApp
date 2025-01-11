import 'package:studiosync/core/domain/repositories/i_lessons_repository.dart';
import 'package:studiosync/modules/trainer/models/lessons_settings_model.dart';


class StreamSettingsLessonsUseCase{
  final ILessonsRepository _lessonsRepository;

  StreamSettingsLessonsUseCase({required ILessonsRepository lessonsRepository})
      : _lessonsRepository = lessonsRepository;

  Stream<LessonsSettingsModel?> call(String trainerId) {
    return _lessonsRepository.streamLessonsSettings(trainerId);
  }
}
