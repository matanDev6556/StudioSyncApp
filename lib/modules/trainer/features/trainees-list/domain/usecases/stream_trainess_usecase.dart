import 'package:flutter/widgets.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/domain/repositories/i_trainees_list_repository.dart';

class StramTrainessListUseCase {
  final ITraineesListRepository _iTraineesListRepository;

  StramTrainessListUseCase({
    required ITraineesListRepository iTraineesListRepository,
  }) : _iTraineesListRepository = iTraineesListRepository;

  Stream<List<TraineeModel>> call(trainerId)  {
    try {
      return  _iTraineesListRepository.streamTraineesOfTrainer(trainerId);
    } catch (e) {
      debugPrint('error from get traineesList use case : $e');
      rethrow;
      
    }
  }
}
