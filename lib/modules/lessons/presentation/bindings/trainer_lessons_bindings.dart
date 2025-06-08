import 'package:get/get.dart';
import 'package:studiosync/modules/lessons/domain/usecases/trainer/add_lesson_usecase.dart';
import 'package:studiosync/modules/lessons/domain/usecases/trainer/delete_lesson_usecase.dart';
import 'package:studiosync/modules/lessons/domain/usecases/trainer/get_registred_trainees_lesson_usecase.dart';
import 'package:studiosync/modules/lessons/domain/usecases/trainer/get_settings_lessons_usecase.dart';
import 'package:studiosync/modules/lessons/domain/usecases/trainer/update_lesson_usecase.dart';
import 'package:studiosync/modules/lessons/domain/usecases/trainer/update_settings_lessons_usecase.dart';
import 'package:studiosync/modules/auth/domain/usecases/get_current_useruid_usecase.dart';
import 'package:studiosync/modules/trainer/features/lesoons/contollers/trainer_lessons_controller.dart';
import 'package:studiosync/modules/trainer/features/lesoons/contollers/trainer_lessons_settings.controller%20.dart';
import 'package:studiosync/modules/trainer/features/lesoons/services/filter_lessons_service.dart';

class LessonsTrainerBindings implements Bindings {
  @override
  void dependencies() {
    //helper filter
    Get.lazyPut(() => LessonTrainerFilterService());

    //usecases (trainer)
    Get.lazyPut(() =>
        GetRegistredTraineesOfLessonUseCase(iLessonsRepository: Get.find()));
    Get.lazyPut(() => AddLessonUseCase(iLessonsRepository: Get.find()));
    Get.lazyPut(() => DeleteLessonUseCase(iLessonsRepository: Get.find()));
    Get.lazyPut(() => UpdateLessonUseCase(iLessonsRepository: Get.find()));
    Get.lazyPut(
        () => GetSettingsLessonsUseCase(iLessonsRepository: Get.find()));
    Get.lazyPut(
        () => UpdateSettingsLessonsUseCase(iLessonsRepository: Get.find()));

    //controllers

    Get.put(TrainerLessonsController(
      getCurrentUserIdUseCase: Get.find<GetCurrentUserIdUseCase>(),
      getRegistredTraineesOfLessonUseCase: Get.find(),
      streamLessonsUseCase: Get.find(),
      addLessonUseCase: Get.find(),
      updateLessonUseCase: Get.find(),
      deleteLessonUseCase: Get.find(),
      cancelLessonUseCase: Get.find(),
      filterService: Get.find(),
    ));

    Get.put(TrainerLessonsSettingsController(
      getSettingsLessonsUseCase: Get.find(),
      updateSettingsLessonsUseCase: Get.find(),
      getCurrentUserIdUseCase: Get.find<GetCurrentUserIdUseCase>(),
    ));
  }
}
