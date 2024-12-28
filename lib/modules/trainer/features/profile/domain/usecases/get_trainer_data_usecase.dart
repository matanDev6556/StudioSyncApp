import 'package:flutter/foundation.dart';
import 'package:studiosync/modules/trainer/features/profile/domain/repositories/i_trainer_repository.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';

class GetTrainerDataUseCase {
  final ITrainerRepository _iTrainerRepository;

  GetTrainerDataUseCase({required ITrainerRepository iTrainerRepository})
      : _iTrainerRepository = iTrainerRepository;

  Future<TrainerModel?> call(String uid) async {
    try {
      return await _iTrainerRepository.getTrainerData(uid);
    } catch (e) {
      debugPrint("error from get trainer use case: \n $e");
      return null;
    }
  }
}
