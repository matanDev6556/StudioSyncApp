import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';

class LogoutUseCase {
  final IAuthRepository _authRepository;

  LogoutUseCase(this._authRepository);

  Future<void> call() async {
    await _authRepository.signOut();
  }
}
