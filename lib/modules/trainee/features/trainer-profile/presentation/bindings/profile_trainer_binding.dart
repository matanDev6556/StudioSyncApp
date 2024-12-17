import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/data/repositories/firestore_trainerprofile_repository.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/domain/repositories/i_trainer_profile_repository.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/domain/usecases/count_trainees_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/domain/usecases/send_request_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/presentation/controllers/trainer_profile_controller.dart';

class ProfileTrainerBinding implements Bindings {
  @override
  void dependencies() {


    // concrete repo use firestore service

    Get.put<ITrainerProfileRepository>(
        TrainerProfileFirestoreRepository(Get.find()));
    // use cases 
    Get.lazyPut(
        () => CountTraineesOfTrainer(Get.find<ITrainerProfileRepository>()));
    Get.lazyPut(
        () => SendRequestUseCase(Get.find<ITrainerProfileRepository>()));

    //controllers
    Get.lazyPut(() => TrainerProfileController(
          countTraineesOfTrainer: Get.find(),
          sendRequestUseCase: Get.find(),
        ));
  }
}
