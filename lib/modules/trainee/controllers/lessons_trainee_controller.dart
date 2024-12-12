import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/modules/trainee/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/controllers/trainer_profile_controller.dart';
import 'package:studiosync/modules/trainee/features/lessons/service/lessons_filter_service.dart';
import 'package:studiosync/modules/trainee/features/lessons/service/lessons_trainee_service.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';
import 'package:studiosync/modules/trainer/models/lessons_settings_model.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';

class LessonsTraineeController extends GetxController {
  final LessonsTraineeService lessonsTraineeService;
  final LessonsTraineeFilterService lessonFilterService;

  LessonsTraineeController({
    required this.lessonsTraineeService,
    required this.lessonFilterService,
  });

  late StreamSubscription<List<LessonModel>> _lessonsSubscription;
  late StreamSubscription<LessonsSettingsModel?> lessonsSettingsSubscription;

  final isLoading = false.obs;
  final _lessons = <LessonModel>[].obs;
  final filteredLessons = <LessonModel>[].obs;
  final selectedDayIndex = (DateTime.now().weekday % 7).obs;

  final Rx<LessonsSettingsModel?> lessonsSettings =
      Rx<LessonsSettingsModel?>(null);

  TraineeModel get trainee => Get.find<TraineeController>().trainee.value!;

  TrainerModel get myTrainer =>
      Get.find<TrainerProfileController>().myTrainer.value!;

  @override
  void onInit() {
    super.onInit();
    _listenToLessonChanges();
    _listenToLessonsSettings();
  }

  @override
  void onClose() {
    _lessonsSubscription.cancel();
    lessonsSettingsSubscription.cancel();
    super.onClose();
  }

  void _listenToLessonChanges() {
    _lessonsSubscription = lessonsTraineeService
        .getUpcomingLessonChanges(trainee.trainerID)
        .listen((updatedList) {
      _lessons.value = updatedList;
      applyFilters();
    });
  }

  void _listenToLessonsSettings() {
    lessonsSettingsSubscription = lessonsTraineeService
        .getLessonsSettingsChanges(trainee.trainerID)
        .listen((settings) {
      if (settings != null) {
        lessonsSettings.value = settings;
      }
    });
  }

  void setDayIndex(int index) {
    selectedDayIndex.value = index;
    applyFilters();
  }

  bool checkIfTraineeInLesson(LessonModel lessonModel) {
    return lessonModel.traineesRegistrations.contains(trainee.userId);
  }

  Future<void> joinLesson(LessonModel lessonModel) async {
    if (trainee.subscription != null &&
        trainee.subscription!.isAllowedTosheduleLesson()) {
      await lessonsTraineeService.addTraineeToLesson(
          trainee.trainerID, lessonModel.id, trainee.userId);
    }
    print(trainee.subscription?.getSub().toMap());
    Get.find<TraineeController>().saveTrainee();
  }

  Future<void> cancleLesson(LessonModel lessonModel) async {
    await lessonsTraineeService.removeTraineeFromLesson(
        trainee.trainerID, lessonModel.id, trainee.userId);

    trainee.subscription?.cancleLesson();
    Get.find<TraineeController>().saveTrainee();
  }

  void applyFilters() {
    filteredLessons.value = lessonFilterService.applyFilters(
        _lessons, selectedDayIndex.value)
      ..sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
  }

  void handleLessonPress(LessonModel lesson) {
    if (checkIfTraineeInLesson(lesson)) {
      cancleLesson(lesson);
    } else if (lesson.isLessonFull()) {
      Validations.showValidationSnackBar('Lesson is full!', Colors.red);
    } else {
      joinLesson(lesson);
    }
  }
}
