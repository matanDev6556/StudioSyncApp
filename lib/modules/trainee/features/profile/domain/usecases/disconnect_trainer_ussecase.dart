import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_mytrainer_repository.dart';


class DisconnectTrainerUseCase {
  final IMyTrainerRepositroy _repository;

  DisconnectTrainerUseCase({required IMyTrainerRepositroy repository})
      : _repository = repository;

  Future<void> execute(TraineeModel traineeModel) async {
    final updatedTrainee = traineeModel.copyWith(trainerID: '');
    updatedTrainee.subscription = null;
    updatedTrainee.startWorOutDate = null;
    await _repository.disconnectedTrainer(updatedTrainee,traineeModel.trainerID);
  }
}
