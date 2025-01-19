import 'package:studiosync/core/domain/repositories/i_lessons_repository.dart';
import 'package:studiosync/modules/lessons/data/model/lessons_settings_model.dart';

class UpdateSettingsLessonsUseCase {
  final ILessonsRepository _iLessonsRepository;

  UpdateSettingsLessonsUseCase({required ILessonsRepository iLessonsRepository})
      : _iLessonsRepository = iLessonsRepository;

  Future<void> call(
      String trainerId, LessonsSettingsModel lessonsSettingsModel) async {
    try {
      await _iLessonsRepository.updateSettingsLessons(
          trainerId, lessonsSettingsModel);
    } catch (e) {
      throw Exception("Failed to update settings lessons: $e");
    }
  }
}
