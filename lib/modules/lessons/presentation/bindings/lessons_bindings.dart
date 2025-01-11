import 'package:get/get.dart';
import 'package:studiosync/modules/lessons/data/repository/lessons_firebase_repository.dart';
import 'package:studiosync/modules/lessons/domain/usecases/cancle_lesson_usecase.dart';
import 'package:studiosync/modules/lessons/domain/usecases/stream_lessons_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/data/repositories/firestore_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_trainee_repository.dart';
import '../../../../core/domain/repositories/i_lessons_repository.dart';

class LessonsBindings implements Bindings {
  @override
  void dependencies() {
    // concrete repos
    Get.put<ILessonsRepository>(
        FirebaseLessonsRepository(firestoreService: Get.find()));
    Get.lazyPut<ITraineeRepository>(
        () => FirestoreTraineeRepository(firestoreService: Get.find()));

   
    // common usecases
    Get.lazyPut(() => CancelLessonUseCase(
        iLessonRepository: Get.find(), iTraineeRepository: Get.find()));
    Get.lazyPut(() => StreamLessonsUseCase(iLessonsRepository: Get.find()));
  }
}
