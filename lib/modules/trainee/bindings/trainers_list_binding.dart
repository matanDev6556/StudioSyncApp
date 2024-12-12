import 'package:get/get.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/controllers/trainers_list_try_controller.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/repositories/firesstore_trainers_list_repository.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/usecases/fetch_trainers_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/usecases/filter_trainers_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/usecases/load_prefrences_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/usecases/save_preference_usecase.dart';
import 'package:studiosync/shared/repositories/interfaces/local_storage_repository.dart';

class TrainersListBinding extends Bindings {
  @override
  void dependencies() {
    // concrete service for repo
    final firestoreService = Get.find<FirestoreService>();
    final localPrefrenes = Get.find<ILocalStorageRepository>();

    //concrete repo using firestore
    final trainersListRepo = Get.put(
        FirestoreTrainersListRepository(firestoreService: firestoreService));

    // use cases
    Get.lazyPut(
        () => FetchTrainersUseCase(trainersListRepository: trainersListRepo));

    Get.lazyPut(
        () => LoadPreferencesUseCase(localStorageRepository: localPrefrenes));

    Get.lazyPut(
        () => SavePreferencesUseCase(localStorageRepository: localPrefrenes));

    Get.lazyPut(() => FilterTrainersUseCase());

    Get.put(
      TrainersListController(
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
      ),
    );
  }
}
