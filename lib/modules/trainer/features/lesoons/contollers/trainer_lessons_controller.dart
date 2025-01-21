import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/modules/lessons/domain/usecases/trainer/add_lesson_usecase.dart';
import 'package:studiosync/modules/lessons/domain/usecases/trainer/delete_lesson_usecase.dart';
import 'package:studiosync/modules/lessons/domain/usecases/trainer/get_registred_trainees_lesson_usecase.dart';
import 'package:studiosync/modules/lessons/domain/usecases/stream_lessons_usecase.dart';
import 'package:studiosync/modules/lessons/domain/usecases/trainer/update_lesson_usecase.dart';
import 'package:studiosync/core/presentation/router/app_router.dart';
import 'package:studiosync/core/presentation/utils/validations.dart';
import 'package:studiosync/modules/auth/domain/usecases/get_current_useruid_usecase.dart';
import 'package:studiosync/modules/lessons/domain/usecases/cancle_lesson_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/lessons/data/model/lesson_model.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/filter_lessons_service.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/registred_trainees_buttom.dart';

class TrainerLessonsController extends GetxController {
  final GetCurrentUserIdUseCase _getCurrentUserIdUseCase;
  final GetRegistredTraineesOfLessonUseCase
      _getRegistredTraineesOfLessonUseCase;
  final StreamLessonsUseCase _streamLessonsUseCase;
  final AddLessonUseCase _addLessonUseCase;
  final UpdateLessonUseCase _updateLessonUseCase;
  final DeleteLessonUseCase _deleteLessonUseCase;
  final CancelLessonUseCase _cancelLessonUseCase;
  final LessonTrainerFilterService filterService;

  TrainerLessonsController({
    required GetCurrentUserIdUseCase getCurrentUserIdUseCase,
    required GetRegistredTraineesOfLessonUseCase
        getRegistredTraineesOfLessonUseCase,
    required AddLessonUseCase addLessonUseCase,
    required UpdateLessonUseCase updateLessonUseCase,
    required DeleteLessonUseCase deleteLessonUseCase,
    required CancelLessonUseCase cancelLessonUseCase,
    required StreamLessonsUseCase streamLessonsUseCase,
    required this.filterService,
  })  : _getCurrentUserIdUseCase = getCurrentUserIdUseCase,
        _getRegistredTraineesOfLessonUseCase =
            getRegistredTraineesOfLessonUseCase,
        _streamLessonsUseCase = streamLessonsUseCase,
        _addLessonUseCase = addLessonUseCase,
        _updateLessonUseCase = updateLessonUseCase,
        _deleteLessonUseCase = deleteLessonUseCase,
        _cancelLessonUseCase = cancelLessonUseCase;

  late String trainerId;
  late StreamSubscription<List<LessonModel>> lessonsSubscription;
  RxList<LessonModel> lessons = <LessonModel>[].obs;

  //filters
  RxList<LessonModel> filteredLessons = <LessonModel>[].obs;
  RxInt selectedDayIndex = (DateTime.now().weekday % 7).obs;
  RxList<TraineeModel> registeredTrainees = <TraineeModel>[].obs;

  RxString statusFilter = 'Active'.obs;
  RxString trainerFilter = 'All'.obs;
  RxString typeFilter = 'All'.obs;
  RxString locationFilter = 'All'.obs;
  List<String> statusFilterOptions = ['All', 'Active', 'Past', 'Upcoming'];

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    String uid = _getCurrentUserIdUseCase() ?? '';
    if (uid.isNotEmpty) {
      trainerId = uid;
      _listenToLessonChanges();
      _setupFilterListeners();
    }
  }

  @override
  void onClose() {
    lessonsSubscription.cancel();
    print('subscription close');
    super.onClose();
  }

  void _setupFilterListeners() {
    ever(selectedDayIndex, (_) => _applyFilters());
    ever(statusFilter, (_) => _applyFilters());
    ever(trainerFilter, (_) => _applyFilters());
    ever(typeFilter, (_) => _applyFilters());
    ever(locationFilter, (_) => _applyFilters());
  }

  void _listenToLessonChanges() {
    lessonsSubscription =
        _streamLessonsUseCase(trainerId).listen((updatedLessons) {
      print('listen....');
      lessons.value = updatedLessons;
      _applyFilters();
    });
  }

  Future<void> onDetailsTap(LessonModel lesson) async {
    try {
      isLoading.value = true;

      registeredTrainees.value = await _getRegistredTraineesOfLessonUseCase(
          trainerId, lesson.traineesRegistrations);

      Get.bottomSheet(
        RegisteredTrainees(
          registeredTrainees: registeredTrainees,
          lessonId: lesson.id,
        ),
        isScrollControlled: true,
      );
    } catch (e) {
      Get.snackbar('Error', 'get registered trainees failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addLesson(LessonModel lesson) async {
    try {
      await _addLessonUseCase(trainerId, lesson);
    } catch (e) {
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    }
  }

  Future<void> editLesson(LessonModel lesson) async {
    try {
      await _updateLessonUseCase(trainerId, lesson);
    } catch (e) {
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    }
  }

  Future<void> deleteLesson(String lessonId) async {
    try {
      await _deleteLessonUseCase(trainerId, lessonId);
    } catch (e) {
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    }
  }

  Future<void> deleteTraineeFromLesson(
      String lessonId, TraineeModel traineeModel) async {
    try {
      isLoading.value = true;
      await _cancelLessonUseCase(
          traineeModel.trainerID, lessonId, traineeModel);

      final lessonIndex = lessons.indexWhere((lesson) => lesson.id == lessonId);
      if (lessonIndex != -1) {
        lessons[lessonIndex].traineesRegistrations.remove(traineeModel.userId);
        lessons.refresh();
      }
      AppRouter.navigateBack();
    } catch (e) {
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilters() {
    filteredLessons.value = filterService.filterLessons(
      lessons,
      selectedDayIndex.value,
      statusFilter.value,
      trainerFilter.value,
      typeFilter.value,
      locationFilter.value,
    );
    filteredLessons.refresh();
  }

  //TODO : try another way
  /*
  List<LessonModel> getLastWeekLessons() {
    DateTime now = DateTime.now();
    DateTime lastWeekStart = now.subtract(Duration(days: now.weekday + 7));
    DateTime lastWeekEnd = now.subtract(Duration(days: now.weekday));

    return lessons
        .where((lesson) =>
            lesson.startDateTime.isAfter(lastWeekStart) &&
            lesson.startDateTime.isBefore(lastWeekEnd))
        .toList();
  }

  Future<void> duplicateLastWeekLessons() async {
    List<LessonModel> lastWeekLessons = getLastWeekLessons();

    List<LessonModel> newLessons = lastWeekLessons.map((lesson) {
      return lesson.copyWith(
        startDateTime: lesson.startDateTime.add(const Duration(days: 7)),
        endDateTime: lesson.endDateTime.add(const Duration(days: 7)),
      );
    }).toList();

    await Future.wait(
      newLessons.map(
        (lesson) => crudService.addLesson(
          trainerId,
          lesson,
          resetId: false,
        ),
      ),
    );
  }
  */
}
