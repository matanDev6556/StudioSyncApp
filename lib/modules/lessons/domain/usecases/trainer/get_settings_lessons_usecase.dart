import 'package:studiosync/core/domain/repositories/i_lessons_repository.dart';
import 'package:studiosync/modules/trainer/models/lessons_settings_model.dart';

class GetSettingsLessonsUseCase {
  final ILessonsRepository _iLessonsRepository;

  GetSettingsLessonsUseCase({required ILessonsRepository iLessonsRepository})
      : _iLessonsRepository = iLessonsRepository;

  Future<LessonsSettingsModel> call(String trainerId) async {
    try {
      return await _iLessonsRepository.getSettingsLessons(trainerId);
    } catch (e) {
      throw Exception("Failed to get settings lessons: $e");
    }
  }
}
