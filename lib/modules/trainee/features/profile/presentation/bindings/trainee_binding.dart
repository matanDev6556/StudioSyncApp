import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:studiosync/core/domain/usecases/pick_image_usecase.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/data/repositories/firestore_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/listen_trainee_updates_use_case.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/save_trainee_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/trainee_controller.dart';

class TraineeBinding extends Bindings {
  @override
  void dependencies() {
    final traineeRepository =
        FirestoreTraineeRepository(Get.find<FirestoreService>());

    Get.put<TraineeController>(
      TraineeController(
        listenToTraineeUpdatesUseCase:
            Get.put(ListenToTraineeUpdatesUseCase(traineeRepository)),
        saveTraineeUseCase: Get.put(SaveTraineeUseCase(traineeRepository)),
        pickImageUseCase: Get.find<PickImageUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
      ),
      permanent: true,
    );
  }
}
