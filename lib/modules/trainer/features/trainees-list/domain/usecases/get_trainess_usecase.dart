import 'package:flutter/widgets.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/domain/repositories/i_trainees_list_repository.dart';

class GetTrainessListUseCase {
  final ITraineesListRepository _iTraineesListRepository;

  GetTrainessListUseCase({
    required ITraineesListRepository iTraineesListRepository,
  }) : _iTraineesListRepository = iTraineesListRepository;

  Future<List<TraineeModel>> call(trainerId) async {
    try {
      return await _iTraineesListRepository.getTraineesOfTrainer(trainerId);
    } catch (e) {
      debugPrint('error from get traineesList use case : $e');
      return [];
    }
  }
}
