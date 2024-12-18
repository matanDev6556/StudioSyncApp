import 'package:get/get.dart';
import 'package:studiosync/modules/auth/data/repositories/firebase_auth_repository.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/modules/auth/domain/usecases/login_usecase.dart';
import 'package:studiosync/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:studiosync/modules/auth/presentation/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginUseCase(Get.find<IAuthRepository>()));
    Get.lazyPut(() => LogoutUseCase(Get.find<FirebaseAuthRepository>()));
    Get.put(LoginController(Get.find(), Get.find()));
  }
}
