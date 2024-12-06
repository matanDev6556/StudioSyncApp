import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/core/services/iauth_service.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/shared/services/image_service.dart';

class TraineeController extends GetxController {
  final ImageService imageService;
  final IAuthService authService;
  final FirestoreService firestoreService;

  TraineeController({
    required this.authService,
    required this.firestoreService,
    required this.imageService,
  });

  Rx<TraineeModel?> trainee = Rx<TraineeModel?>(null);

  final isLoading = false.obs;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _traineeStreamSubscription;

  @override
  void onReady() {
    super.onReady();
    _listenToTraineeUpdates();
  }

  @override
  void onClose() {
    _traineeStreamSubscription?.cancel();
    super.onClose();
  }

  void _listenToTraineeUpdates() {
    final String path;
    final trainerId = trainee.value!.trainerID;

    if (trainerId.isNotEmpty) {
      path = 'trainers/$trainerId/trainees/${trainee.value!.userId}';
    } else {
      path = 'trainees/${trainee.value!.userId}';
    }

    print("Listening to document changes at: $path");

    // מאזינים לכל שינוי במסמך במסלול הנכון
    _traineeStreamSubscription =
        firestoreService.streamDocument(path).listen((snapshot) {
      if (snapshot.exists) {
        final traineeData = snapshot.data() as Map<String, dynamic>;
        updateLocalTrainer(TraineeModel.fromJson(traineeData));
        print("Trainee data updated from Firestore.");
      } else {
        print("Document does not exist at path: $path");
      }
    });
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
      await firestoreService.setDocument(
        'trainers/${trainee.value!.trainerID}/trainees',
        trainee.value!.trainerID,
        trainee.value!.toMap(),
      );
    } else {
      await firestoreService.setDocument(
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
