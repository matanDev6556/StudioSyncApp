import 'package:get/get.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/core/services/firebase/auth_service.dart';
import 'package:studiosync/core/services/firebase/storage_services.dart';
import 'package:studiosync/shared/controllers/tabs_controller.dart';
import 'package:studiosync/shared/models/user_model.dart';
import 'package:studiosync/modules/trainee/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_controller.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';
import 'package:studiosync/core/router/routes.dart';

/*
  This controller is shared between two types of users: trainers and trainees.
  It handles the user authentication, user data retrieval and user role checking.
  It also provides methods for updating the user data in the Firestore database.
*/

class WidgetTreeController<T extends UserModel> extends GetxController {
  final AuthService authService;
  final FirestoreService firestoreService;
  final StorageServices storageServices;

  WidgetTreeController(
    this.authService,
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
    final currentUser = authService.currentUser;

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
    Get.put(
      TraineeController(
          authService: Get.find(),
          firestoreService: Get.find(),
          imageService: Get.find()),
      permanent: true,
    );
    final controller = Get.find<TraineeController>();
    TraineeModel traineeModel = TraineeModel.fromJson(mapUser);
    controller.trainee.value = traineeModel;
    userModel.value = traineeModel;
    Get.offAllNamed(Routes.homeTrainee);
  }
}
