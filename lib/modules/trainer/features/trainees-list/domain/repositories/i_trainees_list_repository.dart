import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

abstract class ITraineesListRepository {
  Future<List<TraineeModel>> getTraineesOfTrainer(String trainerId);
}
