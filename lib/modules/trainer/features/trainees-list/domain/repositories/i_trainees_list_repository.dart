import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

abstract class ITraineesListRepository {
  Stream<List<TraineeModel>>  streamTraineesOfTrainer(String trainerId);
}
