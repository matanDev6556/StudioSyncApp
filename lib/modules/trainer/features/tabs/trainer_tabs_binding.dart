import 'package:get/get.dart';
import 'package:studiosync/core/data/data_source/firebase/firestore_service.dart';
import 'package:studiosync/modules/auth/domain/usecases/get_current_useruid_usecase.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_statistic_controller.dart';
import 'package:studiosync/modules/lessons/presentation/bindings/trainer_lessons_bindings.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/presentation/trainees_binding.dart';
import 'package:studiosync/modules/trainer/features/notifications/presentation/requests_binding.dart';
import 'package:studiosync/modules/trainer/features/profile/presentation/trainer_profile_bindings.dart';

class TrainerTabsBinding extends Bindings {
  final firestoreService = Get.find<FirestoreService>();
  @override
  void dependencies() {
   
    // tabs initial 
    RequestsBinding().dependencies();
    TraineesListBinding().dependencies();
    ProfileTrainerBindings().dependencies();
    LessonsTrainerBindings().dependencies();
    
    // trainer statistics
    _bindStatisticsTab();
  }

  void _bindStatisticsTab() {
    Get.lazyPut(() => TrainerStatsController(
        Get.find(), Get.find<GetCurrentUserIdUseCase>()));
  }
}
