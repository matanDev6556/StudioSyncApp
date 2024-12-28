import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

class SaveTraineeUseCase {
  final ITraineeRepository _repository;

  SaveTraineeUseCase(this._repository);

  Future<void> call(TraineeModel trainee) async {
    await _repository.saveTrainee(trainee);
  }
}
