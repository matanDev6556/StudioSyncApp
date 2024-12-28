import 'package:get/get.dart';
import 'package:studiosync/core/domain/usecases/pick_image_usecase.dart';
import 'package:studiosync/modules/auth/domain/usecases/get_current_useruid_usecase.dart';
import 'package:studiosync/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:studiosync/modules/trainer/features/profile/data/repositories/firestore_trainer_repo.dart';
import 'package:studiosync/modules/trainer/features/profile/domain/repositories/i_trainer_repository.dart';
import 'package:studiosync/modules/trainer/features/profile/domain/usecases/get_trainer_data_usecase.dart';
import 'package:studiosync/modules/trainer/features/profile/domain/usecases/save_trainer_usecase.dart';
import 'package:studiosync/modules/trainer/features/profile/presentation/trainer_controller.dart';

class TrainerProfileBindings extends Bindings {
  @override
  void dependencies() {
    // concrete repo
    Get.put<ITrainerRepository>(
        FirestoreTrainerRepository(firestoreService: Get.find()));

    // use cases
    Get.put(GetTrainerDataUseCase(iTrainerRepository: Get.find()));
    Get.put(SaveTrainerUseCase(iTrainerRepository: Get.find()));

    // controller
    Get.put(
        TrainerController(
          Get.find<GetCurrentUserIdUseCase>(),
          Get.find<GetTrainerDataUseCase>(),
          Get.find<SaveTrainerUseCase>(),
          Get.find<LogoutUseCase>(),
          Get.find<PickImageUseCase>(),
        ),
        permanent: true);
  }
}
