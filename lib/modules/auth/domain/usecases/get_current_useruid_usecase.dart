import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';

class GetCurrentUserIdUseCase {
  final IAuthRepository _authRepository;

  GetCurrentUserIdUseCase(this._authRepository);

  String? call() {
    return _authRepository.userUid;
    
  }
}