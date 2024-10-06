import 'package:get/get.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/core/services/firebase/auth_service.dart';
import 'package:studiosync/core/services/firebase/storage_services.dart';
import 'package:studiosync/core/shared/controllers/tabs_controller.dart';
import 'package:studiosync/core/shared/models/user_model.dart';
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
      this.authService, this.firestoreService, this.storageServices);

  var userModel = Rxn<UserModel>();
  GeneralTabController? tabController;
  final isLoading = false.obs;

  bool get isTrainer => userModel.value?.isTrainerUser ?? false;

  RxInt selectedIndex = 0.obs;
  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  Future<void> checkUserRoleAndRedirect() async {
    final currentUser = authService.currentUser;
    if (currentUser != null) {
      final uid = currentUser.uid;
      try {
        isLoading.value = true;
        final mapUser = await firestoreService.getDocument('users', uid);
        if (mapUser == null) {
          Get.offAllNamed(Routes.signUpAs);
        } else if (mapUser['isTrainer']) {
          await _handleTrainerLogin(mapUser);
        } else {
          await _handleTraineeLogin(mapUser);
        }
      } catch (e) {
        print("Error: $e");
        Get.offAllNamed('/error');
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.offAllNamed(Routes.login);
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
    Get.put(TraineeController(), permanent: true);
    final controller = Get.find<TraineeController>();
    TraineeModel traineeModel = TraineeModel.fromJson(mapUser);
    controller.trainee.value = traineeModel;
    userModel.value = traineeModel;
    Get.offAllNamed(Routes.homeTrainee);
  }
}
