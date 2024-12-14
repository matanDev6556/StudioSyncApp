import 'package:studiosync/modules/auth/domain/repositories/i_signup_repository.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';
import '../../../../modules/auth/domain/repositories/i_auth_repository.dart';

class SignUpTrainerUseCase {
  final IAuthRepository _authRepository;
  final ISignUpRepository _iSignUpRepository;

  SignUpTrainerUseCase(this._authRepository, this._iSignUpRepository);

  Future<void> execute(
      TrainerModel newTrainer, String email, String password) async {
    final user =
        await _authRepository.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      await _iSignUpRepository.createTrainer(newTrainer.copyWith(id: user.uid));
    } else {
      throw Exception("Failed to sign up user.");
    }
  }
}
