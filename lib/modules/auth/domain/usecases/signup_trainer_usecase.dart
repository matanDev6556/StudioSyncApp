import 'package:studiosync/modules/trainer/models/trainer_model.dart';

import '../../../../core/services/firebase/firestore_service.dart';
import '../../../../modules/auth/domain/repositories/i_auth_repository.dart';

class SignUpTrainerUseCase {
  final IAuthRepository _authRepository;
  final FirestoreService _firestoreService;

  SignUpTrainerUseCase(this._authRepository, this._firestoreService);

  Future<void> execute(
      TrainerModel newTrainer, String email, String password) async {
    final user =
        await _authRepository.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      await _firestoreService.setDocument(
        'trainers',
        user.uid,
        newTrainer.copyWith(id: user.uid).toMap(),
      );
    } else {
      throw Exception("Failed to sign up user.");
    }
  }
}
