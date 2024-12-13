import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

abstract class ITraineeRepository {
  Stream<TraineeModel> listenToTraineeUpdates(String path);
  Future<void> saveTrainee(TraineeModel trainee, String path);
  Future<void> updateProfileImage(TraineeModel trainee ,String path);
}
