import 'package:get/instance_manager.dart';
import 'package:studiosync/modules/auth/domain/usecases/get_current_useruid_usecase.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/data/repositories/firestore_traineesList_repository.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/domain/repositories/i_trainees_list_repository.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/domain/usecases/stream_trainess_usecase.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/presentation/trainees_controller.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/presentation/trainess_filter_service.dart';

class TraineesListBinding extends Bindings {
  @override
  void dependencies() {
    // concrete repo
    Get.lazyPut<ITraineesListRepository>(
        () => FirestoreTraineesListRepository(firestoreService: Get.find()));
    // use cases
    Get.lazyPut(
        () => StramTrainessListUseCase(iTraineesListRepository: Get.find()));

    // helper service for filter
    Get.lazyPut(() => TraineeFilterService());
    // controller 
    Get.put(
      TraineesController(
        Get.find<GetCurrentUserIdUseCase>(),
        Get.find<StramTrainessListUseCase>(),
        Get.find(),
      ),
    );
  }
}
