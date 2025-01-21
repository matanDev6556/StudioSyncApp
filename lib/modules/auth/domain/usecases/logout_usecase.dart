import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';

class LogoutUseCase {
  final IAuthRepository _authRepository;

  LogoutUseCase({required IAuthRepository iAuthRepository}): _authRepository = iAuthRepository;

  Future<void> call() async {
    await _authRepository.signOut();
  }
}
