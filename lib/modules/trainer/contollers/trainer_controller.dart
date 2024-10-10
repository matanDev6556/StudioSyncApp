import 'package:get/get.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/core/services/firebase/auth_service.dart';
import 'package:studiosync/shared/services/image_service.dart';
import 'package:studiosync/shared/services/user_firestore_service.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';

class TrainerController extends GetxController {
  final ImageService imageService;
  final AuthService authService;
  final UserFirestoreService userFirestoreService;

  Rx<TrainerModel?> trainer = Rx<TrainerModel?>(null);
  final isLoading = false.obs;

  TrainerController(
      this.imageService, this.userFirestoreService, this.authService);

  void addItemToList<T>(List<T> Function(TrainerModel) getList, T newItem) {
    final list = getList(trainer.value!);
    list.add(newItem);
    saveTrainerToDb();
  }

  void removeItemFromList<T>(List<T> Function(TrainerModel) getList, T item) {
    final list = getList(trainer.value!);
    list.remove(item);
    saveTrainerToDb();
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
    }
  }

  void updateLocalTrainer(TrainerModel updatedTrainer) {
    trainer.value = updatedTrainer;
    trainer.refresh();
  }

  void saveTrainerToDb() async {
    isLoading.value = true;
    await userFirestoreService.updateUserDocument(
      'users',
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
