import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/core/services/firebase/auth_service.dart';
import 'package:studiosync/core/services/firebase/storage_services.dart';
import 'package:studiosync/core/shared/models/user_model.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/modules/trainee/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_controller.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:uuid/uuid.dart';

/*
  This controller is shared between two types of users: trainers and trainees.
  It handles the user authentication, user data retrieval and user role checking.
  It also provides methods for updating the user data in the Firestore database.
*/

class UserController<T extends UserModel> extends GetxController {
  final AuthService authService;
  final FirestoreService firestoreService;

  UserController(this.authService, this.firestoreService);

  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  final isLoading = false.obs;

  bool get isTrainer => userModel.value?.isTrainerUser ?? false;
  final storage = Get.find<StorageServices>();

  RxInt selectedIndex = 0.obs;
  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  Future<String?> pickAndUploadImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        print('picked not null');
        final imageFile = File(pickedFile.path);
        final userId = userModel.value?.userId;

        isLoading.value = true;
        final imgUrl = await storage.uploadImageas(
            imageFile, '$userId/${const Uuid().v4()}.jpg');
        print("imgUrl-----" + imgUrl);
        return imgUrl;
      }
    } catch (e) {
      print('ERROR: ${e.toString()}');
      Validations.showValidationSnackBar(e.toString(), AppStyle.backGrey3);
      return null;
    } finally {
      isLoading.value = false;
    }

    return null;
  }

  void logout() async {
    await authService.signOut();
    Get.offAllNamed(Routes.login);
  }

  void updateDocInFirestore(
      String collection, String docId, Map<String, dynamic> data) async {
    isLoading.value = true;
    await firestoreService.updateDocument(collection, docId, data);
    isLoading.value = false;
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
          // create the spetsific controller for trainer
          Get.put(TrainerController(Get.find(), Get.find()), permanent: true);
          final controller = Get.find<TrainerController>();
          // create the logged in user
          TrainerModel trainerModel = TrainerModel.fromJson(mapUser);
          //assigen the user to the controllers
          controller.trainer.value = trainerModel;
          userModel.value = trainerModel;
          //route to the speysific home view
          Get.offAllNamed(Routes.homeTrainer);
        } else {
          // create the spetsific controller for trainer
          Get.put(TraineeController(Get.find(), Get.find()), permanent: true);
          final controller = Get.find<TraineeController>();
          // create the logged in user
          TraineeModel traineeModel = TraineeModel.fromJson(mapUser);
          //assigen the user to the controllers
          controller.trainer.value = traineeModel;
          userModel.value = traineeModel;
          //route to the speysific home view
          Get.offAllNamed(Routes.homeTrainee);
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
}
