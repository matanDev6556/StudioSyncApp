// subscription_repository.dart
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

abstract class ISubscriptionRepository {
  Future<void> saveSubscription(TraineeModel trainee);
  Future<void> cancelSubscription(TraineeModel trainee);
}