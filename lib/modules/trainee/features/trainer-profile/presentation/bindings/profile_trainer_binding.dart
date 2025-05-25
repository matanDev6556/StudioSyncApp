import 'package:get/get.dart';
import 'package:get/get_connect/sockets/src/socket_notifier.dart';
import 'package:studiosync/modules/trainee/features/profile/data/repositories/firestore_mytrainer_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_mytrainer_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/disconnect_trainer_ussecase.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/fetch_mytrainer_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/my_trainer_controller.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/data/repositories/firestore_trainerprofile_repository.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/domain/repositories/i_trainer_profile_repository.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/domain/usecases/count_trainees_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/domain/usecases/send_request_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/presentation/controllers/trainer_profile_controller.dart';

class ProfileTraineeTabBinding extends Bindings {
  @override
  void dependencies() {
    // concrete repos
    Get.put<IMyTrainerRepositroy>(MyTrainerFirestoreRepository(Get.find()));
    Get.put<ITrainerProfileRepository>(
        TrainerProfileFirestoreRepository(Get.find()));
    // use cases
    Get.lazyPut(() =>
        DisconnectTrainerUseCase(repository: Get.find<IMyTrainerRepositroy>()));
    Get.lazyPut(() => FetchMyTrainerUseCase(Get.find<IMyTrainerRepositroy>()));
    Get.lazyPut(
        () => CountTraineesOfTrainer(iTrainerProfileRepository: Get.find()));
    Get.lazyPut(() => SendRequestUseCase(Get.find()));

    //controllers
    Get.lazyPut(() => MyTrainerController(
          disconnectTrainerUseCase: Get.find(),
          fetchMyTrainerUseCase: Get.find(),
        ));

    Get.lazyPut(() => TrainerProfileController(
        countTraineesOfTrainer: Get.find(), sendRequestUseCase: Get.find()));
  }
}

