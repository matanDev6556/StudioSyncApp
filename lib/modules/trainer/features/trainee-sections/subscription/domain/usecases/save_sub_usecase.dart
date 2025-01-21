import 'package:flutter/material.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/trainee-sections/subscription/domain/repositories/i_subscription_repository.dart';

class SaveSubscriptionUseCase {
  final ISubscriptionRepository _iSubscriptionRepository;

  SaveSubscriptionUseCase(
      {required ISubscriptionRepository iSubscriptionRepository})
      : _iSubscriptionRepository = iSubscriptionRepository;

  Future<void> call(TraineeModel trainee) async {
    try {
      await _iSubscriptionRepository.saveSubscription(trainee);
    } catch (e) {
      debugPrint('error save sub from use case : $e');
    }
  }
}
