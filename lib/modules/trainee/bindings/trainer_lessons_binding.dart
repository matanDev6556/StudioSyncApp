import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/controllers/lessons_trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/lessons/service/lessons_filter_service.dart';
import 'package:studiosync/modules/trainee/features/lessons/service/lessons_trainee_service.dart';

class TrainerLessonsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LessonsTraineeFilterService());
    Get.lazyPut(() => LessonsTraineeService(firestoreService: Get.find()));
    Get.lazyPut(() => LessonsTraineeController(
          lessonsTraineeService: Get.find(),
          lessonFilterService: Get.find(),
        ));
  }
}
