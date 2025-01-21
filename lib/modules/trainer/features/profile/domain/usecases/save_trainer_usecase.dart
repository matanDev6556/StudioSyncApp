import 'package:flutter/foundation.dart';
import 'package:studiosync/modules/trainer/features/profile/data/models/trainer_model.dart';
import 'package:studiosync/modules/trainer/features/profile/domain/repositories/i_trainer_repository.dart';


class SaveTrainerUseCase {
  final ITrainerRepository _iTrainerRepository;

  SaveTrainerUseCase({required ITrainerRepository iTrainerRepository})
      : _iTrainerRepository = iTrainerRepository;

  Future<void> call(TrainerModel trainer) async {
    try {
      await _iTrainerRepository.saveTrainer(trainer);
    } catch (e) {
      debugPrint("error from save trainee use case : $e");
    }
  }
}
