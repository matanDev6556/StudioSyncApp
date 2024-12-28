import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/profile/data/models/trainer_model.dart';


abstract class IMyTrainerRepositroy {
  Future<void> disconnectedTrainer(TraineeModel traineeModel, String trainerID);
  Future<TrainerModel?> fetchMyTrainer(String trainerID);
}
