import 'package:studiosync/modules/trainee/models/trainee_model.dart';

abstract class TraineeRepository {
  Stream<TraineeModel> listenToTraineeUpdates(String path);
  Future<void> saveTrainee(TraineeModel trainee, String path);
  Future<void> updateProfileImage(TraineeModel trainee ,String path);
}
