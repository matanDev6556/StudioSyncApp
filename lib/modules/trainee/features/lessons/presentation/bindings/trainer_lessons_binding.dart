import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/features/lessons/data/repositories/lessons_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/repositories/i_lessons_trainee_repository.dart';

import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/get_lessonsSettings_usecase.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/get_upcomingLessons_usecase.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/join_lesson_usecase.dart';

import 'package:studiosync/modules/trainee/features/lessons/presentation/controllers/lessons_trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/service/lessons_filter_service.dart';


class TrainerLessonsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LessonsTraineeFilterService());

    Get.lazyPut<ILessonsTraineeRepository>(() => LessonsTraineeRepsitory(firestoreService: Get.find()));

    Get.lazyPut(() => LessonsTraineeController(
          getLessonsSettingsUseCase: Get.put( GetLessonsSettingsUseCase(repository: Get.find())),
          getUpcomingLessons: Get.put(GetUpcomingLessonsUseCase(repository: Get.find())),
          joinLessonUseCase:  Get.put(JoinLessonUseCase(repository: Get.find())),
          cancelLessonUseCase: Get.find(),
          lessonFilterService: Get.find(),
        ));
  }
}
