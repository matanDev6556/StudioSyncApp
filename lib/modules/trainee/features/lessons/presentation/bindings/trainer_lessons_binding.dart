import 'package:get/get.dart';
import 'package:studiosync/modules/auth/data/repositories/firebase_auth_repository.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/modules/trainee/features/lessons/data/repositories/lessons_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/repositories/i_lessons_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/get_lessonsSettings_usecase.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/get_upcomingLessons_usecase.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/usecases/join_lesson_usecase.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/controllers/lessons_trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/service/lessons_filter_service.dart';
import 'package:studiosync/modules/trainee/features/profile/data/repositories/firestore_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/get_trainee_usecase.dart';

class TrainerLessonsBinding extends Bindings {
  @override
  void dependencies() {
    // services filter helper
    Get.lazyPut(() => LessonsTraineeFilterService());

    // concrete repo
    Get.lazyPut<ILessonsTraineeRepository>(
        () => LessonsTraineeRepsitory(firestoreService: Get.find()));
    Get.lazyPut<IAuthRepository>(
        () => FirebaseAuthRepository(firebaseAuthService: Get.find()));
    Get.put<ITraineeRepository>(FirestoreTraineeRepository(Get.find()));

    // use cases
    Get.put(GetTraineeDataUseCasee(
        iTraineeRepository: Get.find(), iAuthRepository: Get.find()));

    Get.put(GetLessonsSettingsUseCase(repository: Get.find()));
    Get.put(GetUpcomingLessonsUseCase(repository: Get.find()));
    Get.put(JoinLessonUseCase(
        repository: Get.find(), iTraineeRepository: Get.find()));

    // controller
    Get.lazyPut(() => LessonsTraineeController(
          getLessonsSettingsUseCase: Get.find(),
          getTraineeDataUseCasee: Get.find(),
          getUpcomingLessons: Get.find(),
          joinLessonUseCase: Get.find(),
          cancelLessonUseCase: Get.find(),
          lessonFilterService: Get.find(),
        ));
  }
}
