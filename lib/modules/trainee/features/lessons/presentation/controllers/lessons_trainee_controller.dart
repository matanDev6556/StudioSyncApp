import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/utils/validations.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/cancle_lesson_usecase.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/get_lessonsSettings_usecase.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/get_upcomingLessons_usecase.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/join_lesson_usecase.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/service/lessons_filter_service.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/get_trainee_usecase.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';
import 'package:studiosync/modules/trainer/models/lessons_settings_model.dart';

class LessonsTraineeController extends GetxController {
  final GetUpcomingLessonsUseCase _getUpcomingLessons;
  final GetTraineeDataUseCasee _getTraineeDataUseCasee;
  final GetLessonsSettingsUseCase _getLessonsSettingsUseCase;
  final JoinLessonUseCase _joinLessonUseCase;
  final CancelLessonUseCase _cancelLessonUseCase;
  final LessonsTraineeFilterService lessonFilterService;

  LessonsTraineeController({
    required GetUpcomingLessonsUseCase getUpcomingLessons,
    required GetTraineeDataUseCasee getTraineeDataUseCasee,
    required GetLessonsSettingsUseCase getLessonsSettingsUseCase,
    required JoinLessonUseCase joinLessonUseCase,
    required CancelLessonUseCase cancelLessonUseCase,
    required this.lessonFilterService,
  })  : _getUpcomingLessons = getUpcomingLessons,
        _getTraineeDataUseCasee = getTraineeDataUseCasee,
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
  //TraineeController traineeController = Get.find<TraineeController>();
  late TraineeModel? trainee;

  @override
  void onInit() {
    super.onInit();
    fetchTrainee().then((_) {
      if (trainee != null) {
        _listenToLessonChanges();
        _listenToLessonsSettings();
      } else {
        print("Trainee is null, skipping listeners initialization.");
      }
    });
  }

  @override
  void onClose() {
    _lessonsSubscription.cancel();
    _lessonsSettingsSubscription.cancel();
    super.onClose();
  }

  Future<void> fetchTrainee() async {
    isLoading.value = true;
    try {
      trainee = await _getTraineeDataUseCasee();
      if (trainee == null) {
        print("No trainee data available.");
      }
    } catch (e) {
      print("Error fetching trainee data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _listenToLessonChanges() {
    _lessonsSubscription =
        _getUpcomingLessons(trainee!.trainerID).listen((updatedList) {
      _lessons.value = updatedList;
      applyFilters();
    });
  }

  void _listenToLessonsSettings() {
    _lessonsSettingsSubscription =
        _getLessonsSettingsUseCase(trainee!.trainerID).listen((settings) {
      if (settings != null) {
        print(settings);
        lessonsSettings.value = settings;
      }
    });
  }

  Future<void> joinLesson(LessonModel lessonModel) async {
    isLoading.value = true;
    await _joinLessonUseCase(
      trainee!.trainerID,
      lessonModel.id,
      trainee!,
    );
    isLoading.value = false;
  }

  Future<void> cancleLesson(LessonModel lessonModel) async {
    isLoading.value = true;
    await _cancelLessonUseCase(
      trainee!.trainerID,
      lessonModel.id,
      trainee!,
    );
    isLoading.value = false;
  }

  void applyFilters() {
    filteredLessons.value = lessonFilterService.applyFilters(
        _lessons, selectedDayIndex.value)
      ..sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
  }

  Future<void> handleLessonPress(LessonModel lesson) async {
    if (checkIfTraineeInLesson(lesson)) {
      await cancleLesson(lesson);
    } else if (lesson.isLessonFull()) {
      Validations.showValidationSnackBar('Lesson is full!', Colors.red);
    } else {
      await joinLesson(lesson);
    }
  }

  void setDayIndex(int index) {
    selectedDayIndex.value = index;
    applyFilters();
  }

  bool checkIfTraineeInLesson(LessonModel lessonModel) {
    return lessonModel.traineesRegistrations.contains(trainee!.userId);
  }
}
