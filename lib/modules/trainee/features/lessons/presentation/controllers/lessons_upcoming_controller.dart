import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/modules/lessons/domain/usecases/cancle_lesson_usecase.dart';
import 'package:studiosync/modules/lessons/domain/usecases/stream_trainee_lessons_usecae.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/lessons/data/model/lesson_model.dart';

class UpcomingLessonsController extends GetxController {
  final CancelLessonUseCase _cancelLessonUseCase;
  final StreamTraineeLessonsUseCase _streamTraineeLessonsUseCase;

  TraineeModel? get trainee => Get.find<TraineeController>().trainee.value;

  UpcomingLessonsController({
    required CancelLessonUseCase cancelLessonUseCase,
    required StreamTraineeLessonsUseCase streamTraineeLessonsUseCase,
  })  : _cancelLessonUseCase = cancelLessonUseCase,
        _streamTraineeLessonsUseCase = streamTraineeLessonsUseCase;

  RxList<LessonModel> registeredLessons = <LessonModel>[].obs;

  late StreamSubscription<List<LessonModel>> _lessonsSubscription;

  @override
  void onInit() {
    super.onInit();
    if (trainee?.trainerID.isNotEmpty ?? false) {
      fetchRegisteredLessons();
    }
  }

  @override
  void onClose() {
    _lessonsSubscription.cancel();
    super.onClose();
  }

  void fetchRegisteredLessons() {
    _lessonsSubscription = _streamTraineeLessonsUseCase(
            trainee?.trainerID ?? '', trainee?.userId ?? '')
        .listen((lessonsData) {
      registeredLessons.value = filterUpcomingLessons(lessonsData);
    }, onError: (e) {
      debugPrint("Error fetching registered lessons: $e");
    });
  }

  List<LessonModel> filterUpcomingLessons(List<LessonModel> lessons) {
    final now = DateTime.now();
    return lessons.where((lesson) {
      // Filter based on endDateTime instead of startDateTime
      return lesson.endDateTime.isAfter(now);
    }).toList()
      ..sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
  }

  void cancleLesson(LessonModel lessonModel) {
    _cancelLessonUseCase(trainee?.trainerID ?? '', lessonModel.id, trainee!);
  }
}
