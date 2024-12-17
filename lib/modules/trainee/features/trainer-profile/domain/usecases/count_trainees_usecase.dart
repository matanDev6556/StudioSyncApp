import 'package:studiosync/modules/trainee/features/trainer-profile/domain/repositories/i_trainer_profile_repository.dart';

class CountTraineesOfTrainer {
  final ITrainerProfileRepository _repository;

  CountTraineesOfTrainer(this._repository);

  Future<int> execute(String trainerID) async {
    return _repository.countTraineesOfTrainer(trainerID);
  }
}
