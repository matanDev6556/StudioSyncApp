import 'package:get/get.dart';
import 'package:studiosync/core/presentation/router/app_router.dart';
import 'package:studiosync/core/presentation/router/routes.dart';
import 'package:studiosync/modules/auth/domain/usecases/get_current_useruid_usecase.dart';
import 'package:studiosync/core/data/models/user_model.dart';
import 'package:studiosync/core/domain/usecases/check_role_usecase.dart';

class WidgetTreeController<T extends UserModel> extends GetxController {
  final CheckUserRoleUseCase _checkUserRoleUseCase;
  final GetCurrentUserIdUseCase _getCurrentUserIdUseCase;

  WidgetTreeController({
    required CheckUserRoleUseCase checkUserRoleUseCase,
    required GetCurrentUserIdUseCase getCurrentUserIdUseCase,
  })  : _checkUserRoleUseCase = checkUserRoleUseCase,
        _getCurrentUserIdUseCase = getCurrentUserIdUseCase;

  var userModel = Rxn<UserModel>();
  final isLoading = false.obs;

  Future<void> chckUserAndRedirect() async {
    final uid = _getCurrentUserIdUseCase();
    if (uid == null) {
      AppRouter.navigateTo(Routes.login);
      return;
    }
    // check user role
    String? userRole = await _checkUserRoleUseCase(uid);

    if (userRole == null) {
      AppRouter.navigateOffAllNamed(Routes.signUpAs);
      return;
    }

    if (userRole == 'trainee') {
      AppRouter.navigateOffAllNamed(Routes.homeTrainee);
    } else if (userRole == 'trainer') {
      AppRouter.navigateOffAllNamed(Routes.homeTrainer);
    }
  }
}
