import 'package:flutter/material.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/notifications/domain/repositories/i_requests_repository.dart';

class RejectTraineeUseCase {
  final IRequestsRepository iRequestsRepository;

  RejectTraineeUseCase({required this.iRequestsRepository});

  Future<void> call(TraineeModel trainee, String trainerId) async {
    try {
      await iRequestsRepository.rejectTraineeRequest(trainee, trainerId);
    } catch (e) {
      debugPrint('error from reject trainee use case : $e');
    }
  }
}
