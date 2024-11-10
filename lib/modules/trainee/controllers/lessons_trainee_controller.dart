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
import 'package:studiosync/modules/trainer/models/trainer_model.dart';

class LessonsTraineeController extends GetxController {
  final LessonsTraineeService _lessonsTraineeService;
  final LessonsTraineeFilterService lessonFilterService;
  late StreamSubscription<List<LessonModel>> _lessonsSubscription;

  LessonsTraineeController({
    required LessonsTraineeService lessonsTraineeService,
    required LessonsTraineeFilterService lessonFilterService,
  })  : _lessonsTraineeService = lessonsTraineeService,
        lessonFilterService = lessonFilterService;

  final isLoading = false.obs;
  final _lessons = <LessonModel>[].obs;
  final filteredLessons = <LessonModel>[].obs;
  final selectedDayIndex = (DateTime.now().weekday % 7).obs;

  TraineeModel get trainee => Get.find<TraineeController>().trainee.value!;

  TrainerModel get myTrainer =>
      Get.find<TrainerProfileController>().myTrainer.value!;

  @override
  void onInit() {
    super.onInit();
    _listenToLessonChanges();
  }

  @override
  void onClose() {
    _lessonsSubscription.cancel();
    super.onClose();
  }

  void setDayIndex(int index) {
    selectedDayIndex.value = index;
    applyFilters();
  }

  void _listenToLessonChanges() {
    _lessonsSubscription = _lessonsTraineeService
        .getUpcomingLessonChanges(trainee.trainerID)
        .listen((updatedList) {
      _lessons.value = updatedList;
      applyFilters();
    });
  }

  bool checkIfTraineeInLesson(LessonModel lessonModel) {
    return lessonModel.traineesRegistrations.contains(trainee.userId);
  }

  Future<void> joinLesson(LessonModel lessonModel) async {
    await _lessonsTraineeService.addTraineeToLesson(
        trainee.trainerID, lessonModel.id, trainee.userId);
  }

  Future<void> cancleLesson(LessonModel lessonModel) async {
    await _lessonsTraineeService.removeTraineeFromLesson(
        trainee.trainerID, lessonModel.id, trainee.userId);
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
