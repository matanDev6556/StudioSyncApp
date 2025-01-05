import 'package:studiosync/core/data/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/subscription/domain/repositories/i_subscription_repository.dart';

class FirestoreSubscriptionRepository implements ISubscriptionRepository {
  final FirestoreService _firestoreService;

  FirestoreSubscriptionRepository({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  @override
  Future<void> cancelSubscription(TraineeModel trainee) async {
    await _firestoreService.setDocument(
      'trainers/${trainee.trainerID}/trainees',
      trainee.userId,
      trainee.toMap(),
    );
  }

  @override
  Future<void> saveSubscription(TraineeModel trainee) async {
     await _firestoreService.setDocument(
        'trainers/${trainee.trainerID}/trainees',
        trainee.userId,
        trainee.toMap(),
      );
  }
}
