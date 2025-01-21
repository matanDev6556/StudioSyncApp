import 'package:studiosync/modules/trainer/features/profile/data/models/trainer_model.dart';


abstract class ITrainersListRepository {
  Future<List<TrainerModel>> fetchTrainers(String city);
}
