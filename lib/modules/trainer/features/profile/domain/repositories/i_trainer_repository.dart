import 'package:studiosync/modules/trainer/features/profile/data/models/trainer_model.dart';


abstract class ITrainerRepository {
  Future<void> saveTrainer(TrainerModel trainerModel);
  Future<void> deleteTrainer(TrainerModel trainerModel);
  Future<TrainerModel?> getTrainerData(String trainerId);
}
