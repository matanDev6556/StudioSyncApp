import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/domain/repositories/i_trainer_profile_repository.dart';
import 'package:studiosync/modules/trainer/features/notifications/data/models/request_model.dart';

class SendRequestUseCase {
  final ITrainerProfileRepository repository;

  SendRequestUseCase(this.repository);

  Future<void> execute(TraineeModel traineeModel, String trainerID) async {
    if (traineeModel.trainerID.isNotEmpty) {
      throw Exception("Disconnect from your trainer first!");
    }

    final isRequestExists =
        await repository.checkIfRequestExists(traineeModel.userId, trainerID);

    if (isRequestExists) {
      throw Exception("Request already sent!");
    }

    final request =
        RequestModel(traineeID: traineeModel.userId, trainerID: trainerID);
    await repository.sendRequest(request);
  }
}
