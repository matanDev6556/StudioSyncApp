import 'package:studiosync/shared/models/request_model.dart';

abstract class ITrainerProfileRepository {
  Future<void> sendRequest(RequestModel request);
  Future<int> countTraineesOfTrainer(String trainerID);
  Future<bool> checkIfRequestExists(String traineeID, String trainerID);
}
