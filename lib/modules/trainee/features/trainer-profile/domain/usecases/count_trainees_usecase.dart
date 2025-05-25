import 'package:studiosync/modules/trainee/features/trainer-profile/domain/repositories/i_trainer_profile_repository.dart';


class CountTraineesOfTrainer {
  final ITrainerProfileRepository _iTrainerProfileRepository;

  CountTraineesOfTrainer({required ITrainerProfileRepository iTrainerProfileRepository})
      : _iTrainerProfileRepository = iTrainerProfileRepository;

  Future<int> execute(String trainerID) async {
    return _iTrainerProfileRepository.countTraineesOfTrainer(trainerID);
  }
}
