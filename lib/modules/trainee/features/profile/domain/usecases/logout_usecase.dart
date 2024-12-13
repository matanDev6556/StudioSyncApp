import 'package:studiosync/core/services/interfaces/i_auth_service.dart';

class LogoutUseCase {
  final IAuthService _authService;

  LogoutUseCase({
    required IAuthService authService,
  }) : _authService = authService;

  Future<void> execute() async {
    await _authService.signOut();
  }
}
