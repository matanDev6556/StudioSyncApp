import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/features/lessons/data/repositories/lessons_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/lessons/data/repositories/registred_lessons_repository.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/repositories/i_lessons_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/repositories/i_registredLessons_repository.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/cancle_lesson_usecase.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/get_registredLessons_usecase.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/controllers/lessons_upcoming_controller.dart';
import 'package:studiosync/modules/trainee/features/profile/data/repositories/firestore_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_trainee_repository.dart';

class RegistredLessonsTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ILessonsTraineeRepository>(
        () => LessonsTraineeRepsitory(firestoreService: Get.find()));

    Get.lazyPut<IRegistredLessonsRepository>(() =>
        RegistredTraineeLessonsFirestoreRepository(
            firestoreService: Get.find()));

    Get.put<ITraineeRepository>(FirestoreTraineeRepository(Get.find()));

    // use cases
    Get.lazyPut(() => CancelLessonUseCase(
        repository: Get.find(), iTraineeRepository: Get.find()));
    Get.lazyPut(() => GetRegisteredLessonsUseCase(repository: Get.find()));

    // controllers
    Get.lazyPut(
      () => UpcomingLessonsController(
        cancelLessonUseCase: Get.find(),
        getRegisteredLessonsUseCase: Get.find(),
      ),
    );
  }
}