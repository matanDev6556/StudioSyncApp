import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

class SaveTraineeUseCase {
  final ITraineeRepository _repository;

  SaveTraineeUseCase({required ITraineeRepository iTraineeRepository}): _repository = iTraineeRepository;

  Future<void> call(TraineeModel trainee) async {
    await _repository.saveTrainee(trainee);
  }
}
