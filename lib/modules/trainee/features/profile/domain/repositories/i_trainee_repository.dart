import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

abstract class ITraineeRepository {
  Stream<TraineeModel> listenToTraineeUpdates(String path);
   Future<TraineeModel?> getTraineeData(String uid);
  Future<void> saveTrainee(TraineeModel trainee);
  Future<void> updateProfileImage(TraineeModel trainee);
 
}
