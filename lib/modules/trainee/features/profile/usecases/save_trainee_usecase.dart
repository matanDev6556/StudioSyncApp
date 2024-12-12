import 'package:studiosync/modules/trainee/features/profile/repositories/trainee_repository.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';

class SaveTraineeUseCase {
  final TraineeRepository _repository;

  SaveTraineeUseCase(this._repository);

  Future<void> execute(TraineeModel trainee,String path) async {
   
    await _repository.saveTrainee(trainee, path);
  }
}
