import 'package:get/get.dart';

import 'package:studiosync/core/domain/usecases/pick_image_usecase.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/modules/auth/domain/usecases/signup_trainee_usecase.dart';
import 'package:studiosync/modules/auth/presentation/controllers/signup_trainee_controller.dart';

class SignUpTraineeBinding implements Bindings {
  @override
  void dependencies() {
    
    Get.lazyPut(() => SignUpTraineeUseCase(
        Get.find<IAuthRepository>(), Get.find<FirestoreService>()));
    Get.lazyPut(() => SignUpTraineeController(
          signUpTraineeUseCase: Get.find<SignUpTraineeUseCase>(),
          pickImageUseCase: Get.find<PickImageUseCase>(),
        ));
  }
}
