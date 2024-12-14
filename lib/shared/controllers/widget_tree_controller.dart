import 'package:get/get.dart';
import 'package:studiosync/core/domain/repositories/i_storage_service.dart';
import 'package:studiosync/core/domain/usecases/pick_image_usecase.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/data/repositories/firestore_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/listen_trainee_updates_use_case.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/save_trainee_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/update_image_usecase.dart';

import 'package:studiosync/shared/controllers/tabs_controller.dart';
import 'package:studiosync/shared/models/user_model.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_controller.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';
import 'package:studiosync/core/router/routes.dart';

/*
  This controller is shared between two types of users: trainers and trainees.
  It handles the user authentication, user data retrieval and user role checking.
  It also provides methods for updating the user data in the Firestore database.
*/

class WidgetTreeController<T extends UserModel> extends GetxController {
  final IAuthRepository authRepository;
  final FirestoreService firestoreService;
  final IStorageService storageServices;

  WidgetTreeController(
    this.authRepository,
    this.firestoreService,
    this.storageServices,
  );

  var userModel = Rxn<UserModel>();
  GeneralTabController? tabController;
  final isLoading = false.obs;

  RxInt selectedIndex = 0.obs;
  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  Future<void> checkUserRoleAndRedirect1() async {
    final currentUser = authRepository.currentUser;

    if (currentUser == null) {
      Get.offAllNamed(Routes.login);
      return;
    }

    final uid = currentUser.uid;
    try {
      if (await _tryHandleTrainerLogin(uid)) return;

      final traineeMap = await firestoreService.getDocument('AllTrainees', uid);
      if (traineeMap == null) {
        Get.offAllNamed(Routes.signUpAs);
        return;
      }

      final isConnectedToTrainer = traineeMap['trainerID']?.isNotEmpty ?? false;
      if (!isConnectedToTrainer) {
        await _tryHandleDirectTraineeLogin(uid);
      } else {
        await _tryHandleNestedTraineeLogin(traineeMap['trainerID'], uid);
      }
    } catch (e) {
      print("Error: $e");
      Get.offAllNamed('/error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _tryHandleTrainerLogin(String uid) async {
    final trainerMap = await firestoreService.getDocument('trainers', uid);
    if (trainerMap != null) {
      await _handleTrainerLogin(trainerMap);
      return true;
    }
    return false;
  }

  Future<void> _tryHandleDirectTraineeLogin(String uid) async {
    final directTraineeMap =
        await firestoreService.getDocument('trainees', uid);
    if (directTraineeMap != null) {
      await _handleTraineeLogin(directTraineeMap);
    } else {
      Get.offAllNamed(Routes.signUpAs);
    }
  }

  Future<void> _tryHandleNestedTraineeLogin(
      String trainerId, String uid) async {
    final traineeInTrainerMap = await firestoreService.getDocument(
      'trainers/$trainerId/trainees',
      uid,
    );

    if (traineeInTrainerMap != null) {
      await _handleTraineeLogin(traineeInTrainerMap);
    } else {
      Get.offAllNamed(Routes.signUpAs);
    }
  }

  Future<void> _handleTrainerLogin(Map<String, dynamic> mapUser) async {
    Get.put(TrainerController(Get.find(), Get.find(), Get.find()),
        permanent: true);
    final controller = Get.find<TrainerController>();
    TrainerModel trainerModel = TrainerModel.fromJson(mapUser);
    controller.trainer.value = trainerModel;
    userModel.value = trainerModel;
    Get.offAllNamed(Routes.homeTrainer);
  }

  Future<void> _handleTraineeLogin(Map<String, dynamic> mapUser) async {
    final traineeRepository =
        FirestoreTraineeRepository(Get.find<FirestoreService>());

    Get.put(ListenToTraineeUpdatesUseCase(traineeRepository));
    Get.put(SaveTraineeUseCase(traineeRepository));
    Get.put(UpdateProfileImageUseCase(
        traineeRepository, Get.find<IStorageService>()));

    Get.put<TraineeController>(
      TraineeController(
        listenToTraineeUpdatesUseCase:
            Get.find<ListenToTraineeUpdatesUseCase>(),
        saveTraineeUseCase: Get.find<SaveTraineeUseCase>(),
        pickImageUseCase: Get.find<PickImageUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
      ),
      permanent: true,
    );
    final controller = Get.find<TraineeController>();
    TraineeModel traineeModel = TraineeModel.fromJson(mapUser);
    controller.trainee.value = traineeModel;
    userModel.value = traineeModel;
    Get.offAllNamed(Routes.homeTrainee);
  }
}
