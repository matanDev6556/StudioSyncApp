import 'package:get/get.dart';
import 'package:studiosync/core/presentation/router/app_router.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/fetch_mytrainer_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/domain/usecases/disconnect_trainer_ussecase.dart';
import 'package:studiosync/modules/trainer/features/profile/data/models/trainer_model.dart';


class MyTrainerController extends GetxController {
  final DisconnectTrainerUseCase _disconnectTrainerUseCase;
  final FetchMyTrainerUseCase _fetchMyTrainerUseCase;

  MyTrainerController({
    required DisconnectTrainerUseCase disconnectTrainerUseCase,
    required FetchMyTrainerUseCase fetchMyTrainerUseCase,
  })  : _disconnectTrainerUseCase = disconnectTrainerUseCase,
        _fetchMyTrainerUseCase = fetchMyTrainerUseCase;

  Rx<TrainerModel?> myTrainer = Rx<TrainerModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchMyTrainer(Get.find<TraineeController>().trainee.value!.trainerID);
  }

  Future<void> fetchMyTrainer(String trainerId) async {
    if (trainerId.isEmpty) {
      myTrainer.value = null;
      return;
    }
    myTrainer.value = await _fetchMyTrainerUseCase.execute(trainerId);
  }

  Future<void> disconnectTrainer(TraineeModel trainee) async {
    try {
      await _disconnectTrainerUseCase.execute(trainee);
      myTrainer.value = null;
      AppRouter.navigateBack();
    } catch (e) {
      Get.snackbar('Error', 'Failed to disconnect: $e');
    }
  }
}
