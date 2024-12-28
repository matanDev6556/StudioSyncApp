import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/utils/validations.dart';
import 'package:studiosync/modules/auth/domain/usecases/get_current_useruid_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/filter_lessons_service.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/lessons_crud_service.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/trainer_lessons_service.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/add_edit_lesson_buttom.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/registred_trainees_buttom.dart';

// trainer_lessons_controller.dart
class TrainerLessonsController extends GetxController {
  final GetCurrentUserIdUseCase _getCurrentUserIdUseCase;
  final LessonTrainerFilterService filterService;
  final LessonsCrudService crudService;
  final TrainerLessonsService trainerLessonsService;

  TrainerLessonsController({
    required GetCurrentUserIdUseCase getCurrentUserIdUseCase,
    required this.trainerLessonsService,
    required this.filterService,
    required this.crudService,
  }) : _getCurrentUserIdUseCase = getCurrentUserIdUseCase;

  var isLoading = false.obs;
  late String trainerId;
  RxList<LessonModel> lessons = <LessonModel>[].obs;

  //filters
  RxList<LessonModel> filteredLessons = <LessonModel>[].obs;
  RxInt selectedDayIndex = (DateTime.now().weekday % 7).obs;
  var statusFilter = 'Active'.obs;
  late RxString trainerFilter = 'All'.obs;
  late RxString typeFilter = 'All'.obs;
  late RxString locationFilter = 'All'.obs;

  List<String> statusFilterOptions = ['All', 'Active', 'Past', 'Upcoming'];
  late StreamSubscription<List<LessonModel>> lessonsSubscription;

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
        .getLessonChanges(trainerId)
        .listen((updatedLessons) {
      lessons.value = updatedLessons;
      lessons.refresh();
      _applyFilters();
    });
  }

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
          trainerId,
          lesson.traineesRegistrations,
        );

        Get.bottomSheet(
          RegisteredTrainees(
            registeredTrainees: registeredTrainees,
            lessonId: lesson.id,
          ),
          isScrollControlled: true,
        );
      } else {
        // אם אין מתאמנים רשומים, נציג BottomSheet עם הודעה מתאימה
        Get.bottomSheet(
          RegisteredTrainees(
            registeredTrainees: [],
            lessonId: lesson.id,
          ),
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
      await crudService.addLesson(
       trainerId,
        lesson,
      );
    } catch (e) {
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    }
  }

  Future<void> editLesson(LessonModel lesson) async {
    try {
      await crudService.updateLesson(
       trainerId,
        lesson,
      );
    } catch (e) {
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    }
  }

  Future<void> deleteLesson(String lessonId) async {
    try {
      await crudService.deleteLesson(
       trainerId,
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

  Future<void> deleteTraineeFromLesson(
    String lessonId,
    TraineeModel traineeModel,
  ) async {
    isLoading.value = true;
    //traineeModel.subscription?.cancleLesson();
    await trainerLessonsService.removeTraineeFromLesson(
        traineeModel.trainerID, lessonId, traineeModel.userId);

    // await trainerLessonsService.updateTraineeSub(traineeModel);

    isLoading.value = false;
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
