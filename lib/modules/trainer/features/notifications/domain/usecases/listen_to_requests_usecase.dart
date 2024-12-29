import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/notifications/domain/repositories/i_requests_repository.dart';

class ListenToRequestsUseCase {
  final IRequestsRepository iRequestsRepository;

  ListenToRequestsUseCase({required this.iRequestsRepository});

  Stream<List<TraineeModel>> call(String trainerId) {
    return iRequestsRepository.listenToTrainerRequests(trainerId);
  }
}