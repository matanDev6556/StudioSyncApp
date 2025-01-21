import 'package:flutter/material.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/notifications/domain/repositories/i_requests_repository.dart';

class AproveTraineeUseCase {
  final IRequestsRepository iRequestsRepository;

  AproveTraineeUseCase({required this.iRequestsRepository});

  Future<void> call(TraineeModel trainee, String trainerId) async {
    try {
     
      await iRequestsRepository.approveTraineeRequest(trainee, trainerId);
    } catch (e) {
      debugPrint('error from approve trainee use case : $e ');
    }
  }
}
