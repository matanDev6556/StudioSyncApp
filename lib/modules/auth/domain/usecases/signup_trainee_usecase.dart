import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

import '../../../../core/services/firebase/firestore_service.dart';

class SignUpTraineeUseCase {
  final IAuthRepository _authRepository;
  final FirestoreService _firestoreService;

  SignUpTraineeUseCase(this._authRepository, this._firestoreService);

  Future<void> execute(TraineeModel newTrainee, String password) async {
    final user = await _authRepository.signUpWithEmailAndPassword(
      newTrainee.userEmail,
      password,
    );

    if (user != null) {
      await _firestoreService.setDocument(
        'trainees',
        user.uid,
        newTrainee.copyWith(id: user.uid).toMap(),
      );

      await _firestoreService.setDocument(
        'AllTrainees',
        user.uid,
        {
          'id': user.uid,
          'trainerID': newTrainee.trainerID,
        },
      );
    }
  }
}