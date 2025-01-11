import 'package:flutter/material.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/trainee-sections/subscription/domain/repositories/i_subscription_repository.dart';

class CancleSubscriptionUseCase {
  final ISubscriptionRepository _iSubscriptionRepository;

  CancleSubscriptionUseCase(
      {required ISubscriptionRepository iSubscriptionRepository})
      : _iSubscriptionRepository = iSubscriptionRepository;

  Future<void> call(TraineeModel trainee) async {
    try {
      _iSubscriptionRepository.cancelSubscription(trainee);
    } catch (e) {
      debugPrint('error cancle sub from use case : $e');
    }
  }
}
