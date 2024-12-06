import 'package:get/get.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/core/services/firebase/storage_services.dart';
import 'package:studiosync/core/services/iauth_service.dart';
import 'package:studiosync/modules/auth/controllers/signup_trainer_controller.dart';


class SignUpTrainerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SignUpTrainerController(
        authService: Get.find<IAuthService>(),
        firestoreService: Get.find<FirestoreService>(),
        storageServices: Get.find<StorageServices>(),
      ),
    );
  }
}
