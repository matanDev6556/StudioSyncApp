import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';

abstract class IWidgetTreeRepository {
  Future<String?> checkUserRole(String uid);
  Future<TraineeModel?> getTraineeData(String uid);
  Future<TrainerModel?> getTrainerData(String uid);
}
