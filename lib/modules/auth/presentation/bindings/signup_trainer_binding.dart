import 'package:get/get.dart';
import 'package:studiosync/core/domain/usecases/pick_image_usecase.dart';
import 'package:studiosync/modules/auth/data/repositories/firestore_signup_repository.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_signup_repository.dart';
import 'package:studiosync/modules/auth/domain/usecases/signup_trainer_usecase.dart';
import 'package:studiosync/modules/auth/presentation/controllers/signup_trainer_controller.dart';

class SignUpTrainerBinding implements Bindings {
  @override
  void dependencies() {
     Get.put<ISignUpRepository>(SignUpFirestoreRepository(Get.find()));
    Get.lazyPut(() => SignUpTrainerUseCase(
        Get.find<IAuthRepository>(), Get.find<ISignUpRepository>()));
    Get.lazyPut(
      () => SignUpTrainerController(
        signUpTrainerUseCase: Get.find<SignUpTrainerUseCase>(),
        pickImageUseCase: Get.find<PickImageUseCase>(),
        
      ),
    );
  }
}
