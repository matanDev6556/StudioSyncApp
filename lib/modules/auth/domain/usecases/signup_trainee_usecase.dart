import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_signup_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

class SignUpTraineeUseCase {
  final IAuthRepository _authRepository;
  final ISignUpRepository _iSignUpRepository;

  SignUpTraineeUseCase(this._authRepository, this._iSignUpRepository);

  Future<void> execute(TraineeModel newTrainee, String password) async {
    final user = await _authRepository.signUpWithEmailAndPassword(
      newTrainee.userEmail,
      password,
    );

    if (user != null) {
      await _iSignUpRepository.createTrainee(newTrainee.copyWith(id: user.uid));
    }
  }
}
