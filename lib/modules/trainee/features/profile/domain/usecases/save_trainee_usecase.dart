import 'package:studiosync/modules/trainee/features/profile/domain/repositories/itrainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

class SaveTraineeUseCase {
  final ITraineeRepository _repository;

  SaveTraineeUseCase(this._repository);

  Future<void> execute(TraineeModel trainee,String path) async {
   
    await _repository.saveTrainee(trainee, path);
  }
}
