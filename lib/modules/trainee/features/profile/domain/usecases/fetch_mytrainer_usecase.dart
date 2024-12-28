import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_mytrainer_repository.dart';
import 'package:studiosync/modules/trainer/features/profile/data/models/trainer_model.dart';


class FetchMyTrainerUseCase {
  final IMyTrainerRepositroy _repository;

  FetchMyTrainerUseCase(this._repository);

  Future<TrainerModel?> execute(String trainerID) {
    return _repository.fetchMyTrainer(trainerID);
  }
}
