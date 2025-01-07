import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/features/profile/data/repositories/firestore_mytrainer_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_mytrainer_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/disconnect_trainer_ussecase.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/fetch_mytrainer_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/my_trainer_controller.dart';

class ProfileTraineeTabBinding extends Bindings {
  @override
  void dependencies() {
    // concrete repos
    Get.put<IMyTrainerRepositroy>(MyTrainerFirestoreRepository(Get.find()));
    // use cases
    Get.lazyPut(() =>
        DisconnectTrainerUseCase(repository: Get.find<IMyTrainerRepositroy>()));
    Get.lazyPut(() => FetchMyTrainerUseCase(Get.find<IMyTrainerRepositroy>()));

    //controllers
    Get.lazyPut(() => MyTrainerController(
          disconnectTrainerUseCase: Get.find(),
          fetchMyTrainerUseCase: Get.find(),
        ));
  }
}
