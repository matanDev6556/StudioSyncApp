import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

class ListenToTraineeUpdatesUseCase {
  final ITraineeRepository _repository;

  ListenToTraineeUpdatesUseCase({
    required ITraineeRepository iTraineeRepository,
   
  }) : _repository = iTraineeRepository;

  Stream<TraineeModel> call(TraineeModel traineeModel) {
    final String path = traineeModel.trainerID.isNotEmpty
        ? 'trainers/${traineeModel.trainerID}/trainees/${traineeModel.userId}'
        : 'trainees/${traineeModel.userId}';
    return _repository.listenToTraineeUpdates(path);
  }
}
