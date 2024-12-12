import 'package:studiosync/modules/trainer/models/trainer_model.dart';

abstract class TrainersListRepository {
  Future<List<TrainerModel>> fetchTrainers(String city);
}
