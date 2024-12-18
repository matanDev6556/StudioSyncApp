import 'package:get/get.dart';
import 'package:studiosync/core/domain/repositories/i_storage_service.dart';
import 'package:studiosync/core/domain/usecases/pick_image_usecase.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:studiosync/modules/auth/presentation/bindings/login_bindng.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    // use casees for all the app
    Get.put(PickImageUseCase(Get.find<IStorageService>()));
    Get.put(LogoutUseCase(Get.find<IAuthRepository>()));

    LoginBinding().dependencies();
  }
}
