import 'package:get/get.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/core/services/abstract/i_auth_service.dart';
import 'package:studiosync/core/services/abstract/i_storage_service.dart';
import 'package:studiosync/modules/auth/controllers/signup_controller.dart';


class SignUpTraineeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController(
          authService: Get.find<IAuthService>(),
          firestoreService: Get.find<FirestoreService>(),
          storageService: Get.find<IStorageService>(),
        ));
  }
}
