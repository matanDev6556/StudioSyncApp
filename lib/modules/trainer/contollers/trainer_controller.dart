import 'package:get/get.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/shared/services/image_service.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';

class TrainerController extends GetxController {
  final ImageService imageService;
  final IAuthRepository authService;
  final FirestoreService userFirestoreService ;

  TrainerController(
    this.imageService,
    this.userFirestoreService,
    this.authService,
  );

  Rx<TrainerModel?> trainer = Rx<TrainerModel?>(null);
  final isLoading = false.obs;

  void addItemToList<T>(List<T> Function(TrainerModel) getList, T newItem) {
    final trainerModel = trainer.value!;
    final list = getList(trainerModel);
    if (!list.contains(newItem)) {
      list.add(newItem);
      updateLocalTrainer(trainerModel);
      saveTrainerToDb();
    }
  }

  void removeItemFromList<T>(List<T> Function(TrainerModel) getList, T item) {
    final trainerModel = trainer.value!;
    final list = getList(trainerModel);
    if (list.contains(item)) {
      list.remove(item);
      updateLocalTrainer(trainerModel);
      saveTrainerToDb();
    }
  }

  Future<void> addImage() async {
    isLoading.value = true;
    final imgUrl = await imageService.pickAndUploadImage(trainer.value!.userId);
    isLoading.value = false;
    if (imgUrl != null) {
      addItemToList((trainer) => trainer.imageUrls!, imgUrl);
    }
  }

  Future<void> setNewProfileImg() async {
    isLoading.value = true;
    final imgUrl = await imageService.pickAndUploadImage(trainer.value!.userId);
    isLoading.value = false;
    if (imgUrl != null) {
      updateLocalTrainer(trainer.value!.copyWith(imgUrl: imgUrl));
      saveTrainerToDb();
    }
  }

  void updateLocalTrainer(TrainerModel updatedTrainer) {
    trainer.value = updatedTrainer;
    trainer.refresh();
  }

  void saveTrainerToDb() async {
    isLoading.value = true;
    await userFirestoreService.setDocument(
      'trainers',
      trainer.value!.userId,
      trainer.value!.toMap(),
    );
    isLoading.value = false;
  }

  void logout() async {
    await authService.signOut();
    Get.offAllNamed(Routes.login);
  }
}
