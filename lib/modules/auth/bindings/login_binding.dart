import 'package:get/get.dart';
import 'package:studiosync/core/services/abstract/i_auth_service.dart';
import '../controllers/login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(Get.find<IAuthService>()));
  }
}
