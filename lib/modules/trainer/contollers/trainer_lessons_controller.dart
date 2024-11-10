import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_controller.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/filter_lessons_service.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/lessons_crud_service.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/trainer_lessons_service.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/add_edit_lesson_buttom.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/filters_widget.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/registred_trainees_buttom.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/settings_widget.dart';

// trainer_lessons_controller.dart
class TrainerLessonsController extends GetxController {
  final TrainerController trainerController;
  final LessonTrainerFilterService filterService;
  final LessonsCrudService crudService;
  final TrainerLessonsService trainerLessonsService;

  TrainerLessonsController({ 
    required this.trainerLessonsService,
    required this.trainerController,
    required this.filterService,
    required this.crudService,
  });

  var isLoading = false.obs;
  RxList<LessonModel> lessons = <LessonModel>[].obs;

  //filters
  RxList<LessonModel> filteredLessons = <LessonModel>[].obs;
  RxInt selectedDayIndex = (DateTime.now().weekday % 7).obs;
  var statusFilter = 'Active'.obs;
  late RxString trainerFilter = 'All'.obs;
  late RxString typeFilter = 'All'.obs;
  late RxString locationFilter = 'All'.obs;
  Rx<bool> showLessons = false.obs;

  List<String> statusFilterOptions = ['All', 'Active', 'Past', 'Upcoming'];
  late StreamSubscription<List<LessonModel>> lessonsSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenToLessonChanges();
    _setupFilterListeners();
  }

  @override
  void onClose() {
    lessonsSubscription.cancel();
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
    lessonsSubscription = trainerLessonsService
        .getLessonChanges(trainerController.trainer.value!.userId)
        .listen((updatedLessons) {
      lessons.value = updatedLessons;
      lessons.refresh();
      _applyFilters();
    });
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

  Future<void> onDetailsTap(LessonModel lesson) async {
    try {
      isLoading.value = true;

      if (lesson.traineesRegistrations.isNotEmpty) {
        final registeredTrainees =
            await trainerLessonsService.getRegisteredTrainees(
          trainerController.trainer.value!.userId,
          lesson.traineesRegistrations,
        );

        Get.bottomSheet(
          RegisteredTrainees(registeredTrainees: registeredTrainees),
          isScrollControlled: true,
        );
      } else {
        // אם אין מתאמנים רשומים, נציג BottomSheet עם הודעה מתאימה
        Get.bottomSheet(
          const RegisteredTrainees(registeredTrainees: []),
          isScrollControlled: true,
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addLesson(LessonModel lesson) async {
    try {
      if (!crudService.validateLesson(lesson)) return;

      await crudService.addLesson(
        trainerController.trainer.value!.userId,
        lesson,
      );
    } catch (e) {
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    }
  }

  Future<void> editLesson(LessonModel lesson) async {
    try {
      await crudService.updateLesson(
        trainerController.trainer.value!.userId,
        lesson,
      );
    } catch (e) {
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    }
  }

  Future<void> deleteLesson(String lessonId) async {
    try {
      await crudService.deleteLesson(
        trainerController.trainer.value!.userId,
        lessonId,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showLessonSettingsBottomSheet() {
    Get.bottomSheet(
      LessonSettingsWidget(
        lessonsController: this,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void showLessonFilterBottomSheet() {
    Get.bottomSheet(
      LessonFiltersWidget(
        lessonsController: this,
      ),
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
