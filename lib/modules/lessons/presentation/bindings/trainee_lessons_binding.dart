import 'package:get/get.dart';
import 'package:studiosync/modules/lessons/domain/usecases/traineee/join_lesson_usecase.dart';
import 'package:studiosync/modules/lessons/domain/usecases/stream_settings_lessons_usecase.dart';
import 'package:studiosync/modules/lessons/domain/usecases/stream_trainee_lessons_usecae.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/controllers/lessons_trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/controllers/lessons_upcoming_controller.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/service/lessons_filter_service.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/get_trainee_usecase.dart';

class LessonsTraineeBinding extends Bindings {
  @override
  void dependencies() {
    // services filter helper
    Get.lazyPut(() => LessonsTraineeFilterService());

    // use cases
    Get.put(GetTraineeDataUseCasee(
        iTraineeRepository: Get.find(), iAuthRepository: Get.find()));

    Get.put(StreamSettingsLessonsUseCase(lessonsRepository: Get.find()));
    Get.put(StreamTraineeLessonsUseCase(iLessonsRepository: Get.find()));
    Get.put(JoinLessonUseCase(
        iLessonsRepository: Get.find(), iTraineeRepository: Get.find()));

    // controller
    Get.put(LessonsTraineeController(
      streamLessonsUseCase: Get.find(),
      getTraineeDataUseCasee: Get.find(),
      streamSettingsLessonsUseCase: Get.find(),
      joinLessonUseCase: Get.find(),
      cancelLessonUseCase: Get.find(),
      lessonFilterService: Get.find(),
    ));

    Get.put(
      UpcomingLessonsController(
        cancelLessonUseCase: Get.find(),
        streamTraineeLessonsUseCase: Get.find(),
      ),
    );
  }
}
