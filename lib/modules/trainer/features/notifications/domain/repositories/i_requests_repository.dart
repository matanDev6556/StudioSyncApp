import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';


abstract class IRequestsRepository {
  Future<void> approveTraineeRequest(TraineeModel trainee,String trainerId);
  Future<void> rejectTraineeRequest(TraineeModel trainee,String trainerId);
  Stream<List<TraineeModel>> listenToTrainerRequests(String trainerId);
}
