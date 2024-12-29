import 'package:get/get.dart';
import 'package:studiosync/modules/auth/domain/usecases/get_current_useruid_usecase.dart';
import 'package:studiosync/modules/trainer/features/notifications/presentation/requests_controller.dart';
import 'package:studiosync/modules/trainer/features/notifications/data/repositories/firestore_requests_repository.dart';
import 'package:studiosync/modules/trainer/features/notifications/domain/repositories/i_requests_repository.dart';
import 'package:studiosync/modules/trainer/features/notifications/domain/usecases/approve_trainee_usecase.dart';
import 'package:studiosync/modules/trainer/features/notifications/domain/usecases/listen_to_requests_usecase.dart';
import 'package:studiosync/modules/trainer/features/notifications/domain/usecases/reject_trainee_usecase.dart';

class RequestsBinding extends Bindings {
  @override
  void dependencies() {
    // concrete repo
    Get.put<IRequestsRepository>(
        FirestoreRequestsRepository(firestoreService: Get.find()));
    // use cases
    Get.lazyPut(() => ListenToRequestsUseCase(iRequestsRepository: Get.find()));
    Get.lazyPut(() => AproveTraineeUseCase(iRequestsRepository: Get.find()));
    Get.lazyPut(() => RejectTraineeUseCase(iRequestsRepository: Get.find()));
    
    // controller
    Get.put(
      RequestsController(
        getCurrentUserIdUseCase: Get.find<GetCurrentUserIdUseCase>(),
        listenToRequestsUseCase: Get.find(),
        aproveTraineeUseCase: Get.find(),
        rejectTraineeUseCase: Get.find(),
      
      ),
    );
  }
}
