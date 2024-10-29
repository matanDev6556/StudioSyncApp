import 'package:get/get.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/core/services/firebase/auth_service.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';
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
  Rx<TrainerModel?> myTrainer = Rx<TrainerModel?>(null);

  final isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    fetchMyTrainer();
  }

  void fetchMyTrainer() async {
    if (trainee.value!.trainerID.isNotEmpty) {
      var trainerMap = await firestoreService.getDocument(
          'trainers', trainee.value!.trainerID);
      if (trainerMap != null) {
        myTrainer.value = TrainerModel.fromJson(trainerMap);
      }
    }
  }

  void saveTraineeToDb() async {
    isLoading.value = true;
    await firestoreService.addNastedDocument(
        'trainers',
        trainee.value!.trainerID ,
        'trainees',
        trainee.value!.userId,
        trainee.value!.toMap());
    isLoading.value = false;
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

  void logout() async {
    await authService.signOut();
    Get.offAllNamed(Routes.login);
  }
}
