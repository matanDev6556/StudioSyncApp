import 'package:get/get.dart';
import 'package:studiosync/core/shared/controllers/user_controller.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';

class TrainerController extends UserController {
  Rx<TrainerModel?> trainer = Rx<TrainerModel?>(null);

  TrainerController(super.authService, super.firestoreService);

  // Generic function to add item to the correct list
  void addItemToList<T>(List<T> Function(TrainerModel) getList, T newItem) {
    final list = getList(trainer.value!);
    print('add item to list: $newItem');
    list.add(newItem);

    updateDocInFirestore(
      'users',
      trainer.value!.userId,
      trainer.value!.toMap(),
    );
    trainer.refresh();
  }

  // Generic function to remove item from the correct list
  void removeItemFromList<T>(List<T> Function(TrainerModel) getList, T item) {
    final list = getList(trainer.value!);
    list.remove(item);

    updateDocInFirestore(
      'users',
      trainer.value!.userId,
      trainer.value!.toMap(),
    );
    trainer.refresh();
  }

  void addImage() async {
    final imgUrl = await pickAndUploadImage();
    if (imgUrl != null) {
      addItemToList((trainer) => trainer.imageUrls!, imgUrl);
    }
  }

  void setNewProfileImg() async {
    final imgUrl = await pickAndUploadImage();
    if (imgUrl != null) {
      var newTrainer = trainer.value?.copyWith(imgUrl: imgUrl);
      updateLocalTrainer(newTrainer!);
    }
  }

  void updateLocalTrainer(TrainerModel updatedTrainer) {
    trainer.value = updatedTrainer;
    trainer.refresh();
  }

  void saveNewTrainerToDb() {
    updateDocInFirestore(
      'users',
      trainer.value!.userId,
      trainer.value!.toMap(),
    );
  }
}
