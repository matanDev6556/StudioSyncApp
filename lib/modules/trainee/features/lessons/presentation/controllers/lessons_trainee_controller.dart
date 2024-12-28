import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/utils/validations.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/cancle_lesson_usecase.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/get_lessonsSettings_usecase.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/get_upcomingLessons_usecase.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/join_lesson_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/service/lessons_filter_service.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';
import 'package:studiosync/modules/trainer/models/lessons_settings_model.dart';

class LessonsTraineeController extends GetxController {
  final GetUpcomingLessonsUseCase _getUpcomingLessons;
  final GetLessonsSettingsUseCase _getLessonsSettingsUseCase;
  final JoinLessonUseCase _joinLessonUseCase;
  final CancelLessonUseCase _cancelLessonUseCase;
  final LessonsTraineeFilterService lessonFilterService;

  LessonsTraineeController({
    required GetUpcomingLessonsUseCase getUpcomingLessons,
    required GetLessonsSettingsUseCase getLessonsSettingsUseCase,
    required JoinLessonUseCase joinLessonUseCase,
    required CancelLessonUseCase cancelLessonUseCase,
    required this.lessonFilterService,
  })  : _getUpcomingLessons = getUpcomingLessons,
        _getLessonsSettingsUseCase = getLessonsSettingsUseCase,
        _joinLessonUseCase = joinLessonUseCase,
        _cancelLessonUseCase = cancelLessonUseCase;

  late StreamSubscription<List<LessonModel>> _lessonsSubscription;
  late StreamSubscription<LessonsSettingsModel?> _lessonsSettingsSubscription;

  final isLoading = false.obs;
  final _lessons = <LessonModel>[].obs;
  final filteredLessons = <LessonModel>[].obs;
  final selectedDayIndex = (DateTime.now().weekday % 7).obs;

  final Rx<LessonsSettingsModel?> lessonsSettings =
      Rx<LessonsSettingsModel?>(null);

  //  use trainee controller
  TraineeController traineeController = Get.find<TraineeController>();
  TraineeModel get trainee => traineeController.trainee.value!;

  @override
  void onInit() {
    super.onInit();
    _listenToLessonChanges();
    _listenToLessonsSettings();
  }

  @override
  void onClose() {
    _lessonsSubscription.cancel();
    _lessonsSettingsSubscription.cancel();
    super.onClose();
  }

  void _listenToLessonChanges() {
    _lessonsSubscription =
        _getUpcomingLessons(trainee.trainerID).listen((updatedList) {
      _lessons.value = updatedList;
      applyFilters();
    });
  }

  void _listenToLessonsSettings() {
    _lessonsSettingsSubscription =
        _getLessonsSettingsUseCase(trainee.trainerID).listen((settings) {
      if (settings != null) {
        lessonsSettings.value = settings;
      }
    });
  }

  Future<void> joinLesson(LessonModel lessonModel) async {
    if (trainee.subscription != null &&
        trainee.subscription!.isAllowedTosheduleLesson()) {
      await _joinLessonUseCase(
        trainee.trainerID,
        lessonModel.id,
        trainee.userId,
      );
    }

    traineeController.saveTrainee();
  }

  Future<void> cancleLesson(LessonModel lessonModel) async {
    await _cancelLessonUseCase(
      trainee.trainerID,
      lessonModel.id,
      trainee.userId,
    );

    trainee.subscription?.cancleLesson();
    traineeController.saveTrainee();
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

  void setDayIndex(int index) {
    selectedDayIndex.value = index;
    applyFilters();
  }

  bool checkIfTraineeInLesson(LessonModel lessonModel) {
    return lessonModel.traineesRegistrations.contains(trainee.userId);
  }
}
