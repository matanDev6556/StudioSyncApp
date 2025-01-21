import 'package:get/get.dart';
import 'package:studiosync/core/data/data_source/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/domain/repositories/i_trainers_list_repository.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/presentation/controllers/trainers_list_controller.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/data/repositories/firesstore_trainers_list_repository.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/domain/usecases/fetch_trainers_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/domain/usecases/filter_trainers_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/domain/usecases/load_prefrences_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/domain/usecases/save_preference_usecase.dart';
import 'package:studiosync/core/domain/repositories/i_local_storage_repository.dart';

class TrainersListBinding extends Bindings {
  @override
  void dependencies() {
    // concrete service for repo
    final firestoreService = Get.find<FirestoreService>();
    final sharedPrefrenes = Get.find<ILocalStorageRepository>();

    //concrete repo using firestore
    final trainersListRepo = Get.put<ITrainersListRepository>(
        FirestoreTrainersListRepository(firestoreService: firestoreService));

    // use cases
    Get.lazyPut(
        () => FetchTrainersUseCase(trainersListRepository: trainersListRepo));

    Get.lazyPut(
        () => LoadPreferencesUseCase(localStorageRepository: sharedPrefrenes));

    Get.lazyPut(
        () => SavePreferencesUseCase(localStorageRepository: sharedPrefrenes));

    Get.lazyPut(() => FilterTrainersUseCase());

    Get.put(
      TrainersListController(
        Get.find<FetchTrainersUseCase>(),
        Get.find<LoadPreferencesUseCase>(),
        Get.find<SavePreferencesUseCase>(),
        Get.find<FilterTrainersUseCase>(),
      ),
    );
  }
}
