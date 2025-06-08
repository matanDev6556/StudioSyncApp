import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:studiosync/modules/auth/data/repositories/firebase_auth_repository.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:studiosync/core/domain/usecases/pick_image_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/data/repositories/firestore_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/get_trainee_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/listen_trainee_updates_use_case.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/save_trainee_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/trainee_controller.dart';

class TraineeBinding extends Bindings {
  @override
  void dependencies() {
    //concrete repo
    Get.put<ITraineeRepository>(
        FirestoreTraineeRepository(firestoreService: Get.find()));
    Get.put<IAuthRepository>(
        FirebaseAuthRepository(firebaseAuthService: Get.find()));

    //use cases

    Get.put(ListenToTraineeUpdatesUseCase(iTraineeRepository: Get.find()));
    Get.put(SaveTraineeUseCase(iTraineeRepository: Get.find()));
    Get.put(GetTraineeDataUseCasee(
        iTraineeRepository: Get.find(), iAuthRepository: Get.find()));

    //controlers
    Get.put<TraineeController>(
      TraineeController(
        getTraineeDataUseCase: Get.find(),
        listenToTraineeUpdatesUseCase: Get.find(),
        saveTraineeUseCase: Get.find(),
        pickImageUseCase: Get.find<PickImageUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
      ),
      permanent: true,
    );
  }
}
