import 'package:get/get.dart';
import 'package:studiosync/core/domain/usecases/pick_image_usecase.dart';
import 'package:studiosync/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:studiosync/modules/auth/presentation/bindings/login_bindng.dart';


// this bindings aplly by widget tree bindings
class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    LoginBinding().dependencies();

    // use casees for all the app
    Get.put(PickImageUseCase(iStorageService: Get.find()));
    Get.put(LogoutUseCase(iAuthRepository: Get.find()));
  }
}
