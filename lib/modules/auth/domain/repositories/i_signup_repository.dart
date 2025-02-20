import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/profile/data/models/trainer_model.dart';

abstract class ISignUpRepository {
   Future<void> createTrainee(TraineeModel trainee);
   Future<void> createTrainer(TrainerModel trainer);
}
