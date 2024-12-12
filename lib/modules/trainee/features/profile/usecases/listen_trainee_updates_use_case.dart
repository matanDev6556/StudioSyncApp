import 'package:studiosync/modules/trainee/features/profile/repositories/trainee_repository.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';

class ListenToTraineeUpdatesUseCase {
  final TraineeRepository _repository;

  ListenToTraineeUpdatesUseCase(this._repository);

  Stream<TraineeModel> execute(String path) {
    return _repository.listenToTraineeUpdates(path);
  }
}