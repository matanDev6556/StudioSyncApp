import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/lessons/service/upcoming_lessons_service.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';

class UpcomingLessonsController extends GetxController {
  final UpcomingLessonsTraineeService upcomingLessonsTraineeService;
  final trainee = Get.find<TraineeController>().trainee.value;

  UpcomingLessonsController({required this.upcomingLessonsTraineeService});

  RxList<LessonModel> registeredLessons = <LessonModel>[].obs;

  late StreamSubscription<List<LessonModel>> lessonsSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchRegisteredLessons();
  }

  @override
  void onClose() {
    lessonsSubscription.cancel();
    super.onClose();
  }

  void fetchRegisteredLessons() {
    lessonsSubscription = upcomingLessonsTraineeService
        .getUpcomingRegisteredLessonsForTrainee(
            trainee!.trainerID, trainee!.userId)
        .listen((lessonsData) {
      registeredLessons.value = filterUpcomingLessons(lessonsData);
    }, onError: (e) {
      debugPrint("Error fetching registered lessons: $e");
    });
  }

  List<LessonModel> filterUpcomingLessons(List<LessonModel> lessons) {
    final now = DateTime.now();
    return lessons.where((lesson) {
      return lesson.startDateTime.isAfter(now) ||
          lesson.startDateTime.isAtSameMomentAs(now);
    }).toList()
      ..sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
  }

  void cancleLesson(LessonModel lessonModel) {
    upcomingLessonsTraineeService.removeTraineeFromLesson(
        trainee!.trainerID, lessonModel.id, trainee!.userId);
  }
}
