import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/lessons/service/upcoming_lessons_service.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';

class UpcomingLessonsController extends GetxController {
  final UpcomingLessonsTraineeService upcomingLessonsTraineeService;
  TraineeModel get trainee => Get.find<TraineeController>().trainee.value!;

  UpcomingLessonsController({required this.upcomingLessonsTraineeService});

  RxList<LessonModel> registeredLessons = <LessonModel>[].obs;

  late StreamSubscription<List<LessonModel>> lessonsSubscription;

  Timer? _filterTimer;

  @override
  void onInit() {
    super.onInit();
    fetchRegisteredLessons();
   
  }

  @override
  void onClose() {
    lessonsSubscription.cancel();
    _filterTimer?.cancel();
    super.onClose();
  }

  void fetchRegisteredLessons() {
    lessonsSubscription = upcomingLessonsTraineeService
        .getUpcomingRegisteredLessonsForTrainee(
            trainee.trainerID, trainee.userId)
        .listen((lessonsData) {
      registeredLessons.value = filterUpcomingLessons(lessonsData);
    }, onError: (e) {
      debugPrint("Error fetching registered lessons: $e");
    });
  }

  List<LessonModel> filterUpcomingLessons(List<LessonModel> lessons) {
    print('_filterTimer');
    final now = DateTime.now();
    return lessons.where((lesson) {
      // Filter based on endDateTime instead of startDateTime
      return lesson.endDateTime.isAfter(now);
    }).toList()
      ..sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
  }

  void cancleLesson(LessonModel lessonModel) {
    upcomingLessonsTraineeService.removeTraineeFromLesson(
        trainee.trainerID, lessonModel.id, trainee.userId);

    trainee.subscription?.cancleLesson();
    Get.find<TraineeController>().saveTrainee();
  }

}
