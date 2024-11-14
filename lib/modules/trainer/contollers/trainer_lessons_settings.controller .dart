import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_controller.dart';

import 'package:studiosync/modules/trainer/models/lessons_settings_model.dart';

class TrainerLessonsSettingsController extends GetxController {
  final FirestoreService firestoreService;
  TrainerLessonsSettingsController({required this.firestoreService});

  final Rx<LessonsSettingsModel> lessonsSettings =
      Rx<LessonsSettingsModel>(LessonsSettingsModel());

  final RxBool isLoading = RxBool(false);

  LessonsSettingsModel get settings => lessonsSettings.value;

  get trainerId => Get.find<TrainerController>().trainer.value!.userId;

  @override
  void onReady() {
    super.onReady();
    fetchLessonsSettings();
  }

  Future<void> fetchLessonsSettings() async {
    isLoading.value = true;
    try {
      final settings = await firestoreService.getDocument(
          'trainers/$trainerId/settings', 'lessonsSettings');
      if (settings != null) {
        lessonsSettings.value = LessonsSettingsModel.fromMap(settings);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateLocalLessons(LessonsSettingsModel updatedSettings) {
    lessonsSettings.value = updatedSettings;
  }

  Future<void> updateLessonsSettings(
    LessonsSettingsModel updatedSettings,
  ) async {
    isLoading.value = true;
    try {
      await firestoreService.updateDocument('trainers/$trainerId/settings',
          'lessonsSettings', updatedSettings.toMap());
      lessonsSettings.value = updatedSettings;
      Get.snackbar(
        'Success',
        'Lessons settings updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      updateLocalLessons(updatedSettings);
    }
  }
}
