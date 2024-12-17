import 'package:studiosync/modules/trainer/models/trainer_model.dart';

abstract class ITrainersListRepository {
  Future<List<TrainerModel>> fetchTrainers(String city);
}
