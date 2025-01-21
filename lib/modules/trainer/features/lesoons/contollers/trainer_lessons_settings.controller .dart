import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/modules/lessons/data/model/lessons_settings_model.dart';
import 'package:studiosync/modules/lessons/domain/usecases/trainer/get_settings_lessons_usecase.dart';
import 'package:studiosync/modules/lessons/domain/usecases/trainer/update_settings_lessons_usecase.dart';
import 'package:studiosync/core/presentation/utils/validations.dart';
import 'package:studiosync/modules/auth/domain/usecases/get_current_useruid_usecase.dart';

class TrainerLessonsSettingsController extends GetxController {
  
  final GetCurrentUserIdUseCase getCurrentUserIdUseCase;
  final GetSettingsLessonsUseCase getSettingsLessonsUseCase;
  final UpdateSettingsLessonsUseCase updateSettingsLessonsUseCase;

  TrainerLessonsSettingsController({
    required this.getCurrentUserIdUseCase,
    required this.getSettingsLessonsUseCase,
    required this.updateSettingsLessonsUseCase,
  });

  final Rx<LessonsSettingsModel> lessonsSettings =
      Rx<LessonsSettingsModel>(LessonsSettingsModel());

  LessonsSettingsModel get settings => lessonsSettings.value;

  RxBool isLoading = RxBool(false);
  Rx<bool?> isAlloweingToSheduleNow = Rx<bool?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchLessonsSettings();
  }

  Future<void> fetchLessonsSettings() async {
    isLoading.value = true;
    try {
      final trainerId = getCurrentUserIdUseCase();

      lessonsSettings.value = await getSettingsLessonsUseCase(trainerId ?? '');

      isAlloweingToSheduleNow.value =
          lessonsSettings.value.isAllowedToSchedule();
    } catch (e) {
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void updateLocalLessons(LessonsSettingsModel updatedSettings) {
    lessonsSettings.value = updatedSettings;
    isAlloweingToSheduleNow.value = updatedSettings.isAllowedToSchedule();
  }

  Future<void> updateLessonsSettings() async {
    isLoading.value = true;
    try {
      final trainerId = getCurrentUserIdUseCase() ?? ' ';
      await updateSettingsLessonsUseCase(trainerId, settings);

      Validations.showValidationSnackBar(
          'Lessons settings updated successfully', Colors.green);
     
    } catch (e) {
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
}
