import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/modules/lessons/data/model/lessons_settings_model.dart';
import 'package:studiosync/modules/lessons/domain/usecases/traineee/join_lesson_usecase.dart';
import 'package:studiosync/modules/lessons/domain/usecases/stream_lessons_usecase.dart';
import 'package:studiosync/modules/lessons/domain/usecases/stream_settings_lessons_usecase.dart';
import 'package:studiosync/core/presentation/utils/validations.dart';
import 'package:studiosync/modules/lessons/domain/usecases/cancle_lesson_usecase.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/service/lessons_filter_service.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/get_trainee_usecase.dart';
import 'package:studiosync/modules/lessons/data/model/lesson_model.dart';

class LessonsTraineeController extends GetxController {
  final StreamLessonsUseCase _streamLessonsUseCase;
  final GetTraineeDataUseCasee _getTraineeDataUseCasee;
  final StreamSettingsLessonsUseCase _streamSettingsLessonsUseCase;
  final JoinLessonUseCase _joinLessonUseCase;
  final CancelLessonUseCase _cancelLessonUseCase;
  final LessonsTraineeFilterService lessonFilterService;

  LessonsTraineeController({
    required StreamLessonsUseCase streamLessonsUseCase,
    required GetTraineeDataUseCasee getTraineeDataUseCasee,
    required StreamSettingsLessonsUseCase streamSettingsLessonsUseCase,
    required JoinLessonUseCase joinLessonUseCase,
    required CancelLessonUseCase cancelLessonUseCase,
    required this.lessonFilterService,
  })  : _streamLessonsUseCase = streamLessonsUseCase,
        _getTraineeDataUseCasee = getTraineeDataUseCasee,
        _streamSettingsLessonsUseCase = streamSettingsLessonsUseCase,
        _joinLessonUseCase = joinLessonUseCase,
        _cancelLessonUseCase = cancelLessonUseCase;

  late TraineeModel? trainee;
  late StreamSubscription<List<LessonModel>> _lessonsSubscription;
  late StreamSubscription<LessonsSettingsModel?> _lessonsSettingsSubscription;


  //state
  final isLoading = false.obs;
  final _lessons = <LessonModel>[].obs;
  final filteredLessons = <LessonModel>[].obs;
  final selectedDayIndex = (DateTime.now().weekday % 7).obs;

  final Rx<LessonsSettingsModel?> lessonsSettings =
      Rx<LessonsSettingsModel?>(null);

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
        _streamLessonsUseCase(trainee!.trainerID).listen((updatedList) {
      _lessons.value = updatedList;
      applyFilters();
    });
  }

  void _listenToLessonsSettings() {
    _lessonsSettingsSubscription =
        _streamSettingsLessonsUseCase(trainee!.trainerID).listen((settings) {
      if (settings != null) {
        lessonsSettings.value = settings;
      }
    });
  }

  Future<void> joinLesson(LessonModel lessonModel) async {
    isLoading.value = true;
    try {
      await _joinLessonUseCase(trainee!, lessonModel.id);
    } catch (e) {
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancleLesson(LessonModel lessonModel) async {
    isLoading.value = true;
    await _cancelLessonUseCase(trainee!.trainerID, lessonModel.id, trainee!);
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
