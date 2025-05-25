import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/domain/repositories/i_trainer_profile_repository.dart';
import 'package:studiosync/modules/trainer/features/notifications/data/models/request_model.dart';

// this usecase is used to send a request to a trainer
class SendRequestUseCase {
  final ITrainerProfileRepository repository;

  SendRequestUseCase(this.repository);

}
