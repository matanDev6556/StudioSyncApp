import 'package:get/get.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/core/services/firebase/auth_service.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/shared/services/image_service.dart';

class TraineeController extends GetxController {
  final ImageService imageService;
  final AuthService authService;
  final FirestoreService firestoreService;

  TraineeController({
    required this.authService,
    required this.firestoreService,
    required this.imageService,
  });

  Rx<TraineeModel?> trainee = Rx<TraineeModel?>(null);

  final isLoading = false.obs;

  //TODO : move this function to trainer module because he need to confirm or not this connect
  void connectToTrainer(String trainerID) async {
    // add trainne to trainees sub coll

    if (trainee.value != null) {
      final updatedTrainee = trainee.value!
          .copyWith(trainerID: trainerID, startWorkOutDate: DateTime.now());

      isLoading.value = true;
      await firestoreService.addNastedDocument(
        'trainers',
        trainerID,
        'trainees',
        trainee.value!.userId,
        updatedTrainee.toMap(),
      );

      // delete the trainee from general coll trainees
      await firestoreService.deleteDocument('trainees', trainee.value!.userId);

      // update trainerID in allTrainees coll
      await firestoreService.updateDocument(
        'AllTrainees',
        trainee.value!.userId,
        {'id': trainee.value!.userId, 'trainerID': trainerID},
      );

      isLoading.value = false;

      // update localy

      trainee.value = updatedTrainee;
    }
  }

  Future<void> setNewProfileImg() async {
    isLoading.value = true;
    final imgUrl = await imageService.pickAndUploadImage(trainee.value!.userId);
    isLoading.value = false;
    if (imgUrl != null) {
      updateLocalTrainer(trainee.value!.copyWith(imgUrl: imgUrl));
    }
  }

  void updateLocalTrainer(TraineeModel updatedTrainee) {
    trainee.value = updatedTrainee;
    trainee.refresh();
  }

  void saveTraineeToDb() async {
    isLoading.value = true;

    if (trainee.value!.trainerID.isNotEmpty) {
      await firestoreService.addNastedDocument(
        'trainers',
        trainee.value!.trainerID,
        'trainees',
        trainee.value!.userId,
        trainee.value!.toMap(),
      );
    } else {
      await firestoreService.updateDocument(
        'trainees',
        trainee.value!.userId,
        trainee.value!.toMap(),
      );
    }
    isLoading.value = false;
  }

  void logout() async {
    await authService.signOut();
    Get.offAllNamed(Routes.login);
  }
}
