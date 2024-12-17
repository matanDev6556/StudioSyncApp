import 'package:flutter/foundation.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/repositories/i_lessons_trainee_repository.dart';
import 'package:studiosync/modules/trainer/models/lessons_settings_model.dart';

class GetLessonsSettingsUseCase {
  final ILessonsTraineeRepository _repository;

  GetLessonsSettingsUseCase({required ILessonsTraineeRepository repository}): _repository = repository;

  Stream<LessonsSettingsModel?> call(String trainerId) {
    try {
      return _repository.getLessonsSettings(trainerId);
    } catch (e) {
      debugPrint("Error getting lessons settings use case: $e");
      return Stream.value(null);
    }
  }
}
