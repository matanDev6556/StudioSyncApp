import 'package:studiosync/modules/trainee/features/profile/domain/repositories/itrainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

class ListenToTraineeUpdatesUseCase {
  final ITraineeRepository _repository;

  ListenToTraineeUpdatesUseCase(this._repository);

  Stream<TraineeModel> execute(String path) {
    return _repository.listenToTraineeUpdates(path);
  }
}