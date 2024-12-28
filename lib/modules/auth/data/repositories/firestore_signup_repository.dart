import 'package:studiosync/core/data/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_signup_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';

class SignUpFirestoreRepository implements ISignUpRepository {
  final FirestoreService _firestoreService;

  SignUpFirestoreRepository(this._firestoreService);

  @override
  Future<void> createTrainee(TraineeModel trainee) async {
    await _firestoreService.setDocument(
      'trainees',
      trainee.userId,
      trainee.toMap(),
    );

    await _firestoreService.setDocument(
      'AllTrainees',
      trainee.userId,
      {
        'id': trainee.userId,
        'trainerID': trainee.trainerID,
      },
    );
  }

  @override
  Future<void> createTrainer(TrainerModel trainer) async {
    await _firestoreService.setDocument(
      'trainers',
      trainer.userId,
      trainer.toMap(),
    );
  }
}
