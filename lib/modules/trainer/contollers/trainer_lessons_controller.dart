import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/utils/dates.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_controller.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/filter_lessons_service.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/trainer_lessons_service.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/add_edit_lesson_buttom.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/registred_trainees_list.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/settings_buttom.dart';
import 'package:uuid/uuid.dart';

class TrainerLessonsController extends GetxController {
  final TrainerController trainerController;
  final LessonFilterService filterService;

  final TrainerLessonsService trainerLessonsService;

  TrainerLessonsController({
    required this.trainerLessonsService,
    required this.trainerController,
    required this.filterService,
  });
  var isLoading = false.obs;

  RxList<LessonModel> lessons = <LessonModel>[].obs;
  RxList<LessonModel> filteredLessons = <LessonModel>[].obs;

  RxInt selectedDayIndex = (DateTime.now().weekday % 7).obs;

  var statusFilter = 'Active'.obs;

  late RxString trainerFilter = 'All'.obs;

  late RxString typeFilter = 'All'.obs;

  late RxString locationFilter = 'All'.obs;

  Rx<bool> showLessons = false.obs;

  List<String> statusFilterOptions = [
    'All',
    'Active',
    'Past',
    'Upcoming',
  ];

  // Subscriptions to listen for changes
  late StreamSubscription<List<LessonModel>> lessonsSubscription;

  @override
  void onInit() {
    super.onInit();

    _listenToLessonChanges();
    ever(selectedDayIndex, (_) => _applyFilters());
    ever(statusFilter, (_) => _applyFilters());
    ever(trainerFilter, (_) => _applyFilters());
    ever(typeFilter, (_) => _applyFilters());
    ever(locationFilter, (_) => _applyFilters());
  }

  @override
  void onClose() {
    // Cancel the stream subscriptions when the controller is disposed
    lessonsSubscription.cancel();
    super.onClose();
  }

  // Listen to lesson changes for the trainer
  void _listenToLessonChanges() {
    lessonsSubscription = trainerLessonsService
        .getLessonChanges(trainerController.trainer.value!.userId)
        .listen((updatedLessons) {
      lessons.value = updatedLessons;
      lessons.refresh();
      _applyFilters();
    });
  }

  Future<List<TraineeModel>> getTraineesByIds(List<String> traineeIds) async {
    try {
      return await trainerLessonsService.getTraineesByIds(traineeIds);
    } catch (e) {
      print("Error fetching trainees: $e");
      return [];
    }
  }

  void onDetailsTap(LessonModel lesson) async {
    isLoading.value = true;
    List<TraineeModel> registeredTrainees =
        await getTraineesByIds(lesson.traineesRegistrations);
    isLoading.value = false;

    // הצגת ה־BottomSheet
    Get.bottomSheet(
      RegistredTrainees(registeredTrainees: registeredTrainees),
      isScrollControlled: true,
    );
  }

  Future<void> addLesson(LessonModel lesson) async {
    if (!validateForEmptyFields(lesson)) {
      print(lesson.toJson());
      return;
    }

    try {
      await trainerLessonsService.addLesson(
        trainerController.trainer.value!.userId,
        lesson.copyWith(
          id: const Uuid().v4(),
          trainerID: trainerController.trainer.value!.userId,
          day: DatesUtils.getDayFromIndex(lesson.startDateTime.day),
          traineesRegistrations: [],
        ),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to add lesson: $e");
    }
  }

  Future<void> editLesson(LessonModel lesson) async {
    try {
      await trainerLessonsService.updateLesson(
          trainerController.trainer.value!.userId, lesson);
    } catch (e) {
      Validations.showValidationSnackBar(
          'Failed to update lesson: $e', Colors.red);
    }
  }

  void deleteLesson(String lessonId) async {
    try {
      await trainerLessonsService.deleteLesson(
          trainerController.trainer.value!.userId, lessonId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete the lesson: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

  bool validateForEmptyFields(LessonModel? lesson) {
    if (lesson != null) {
      if (lesson.typeLesson.isEmpty) {
        Validations.showValidationSnackBar(
            'Type is required!', Colors.redAccent);
        return false;
      }
      if (lesson.location.isEmpty) {
        Validations.showValidationSnackBar(
            'Location is required!', Colors.redAccent);
        return false;
      }
      if (lesson.trainerName.isEmpty) {
        Validations.showValidationSnackBar(
            'Trainer name is required!', Colors.redAccent);
        return false;
      }
    } else {
      return false;
    }
    return true;
  }

  void showLessonSettingsBottomSheet() {
    Get.bottomSheet(
      LessonSettingsBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void showLessonBottomSheet({
    required String title,
    LessonModel? lesson,
    required Function(LessonModel) onSave,
  }) {
    Get.bottomSheet(
      LessonEditBottomSheet(
        title: title,
        lesson: lesson,
        onSave: onSave,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}
