import 'package:get/get.dart';
import 'package:studiosync/core/domain/usecases/pick_image_usecase.dart';
import 'package:studiosync/core/presentation/router/app_router.dart';
import 'package:studiosync/core/presentation/router/routes.dart';
import 'package:studiosync/modules/auth/domain/usecases/get_current_useruid_usecase.dart';
import 'package:studiosync/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:studiosync/modules/trainer/features/profile/data/models/trainer_model.dart';
import 'package:studiosync/modules/trainer/features/profile/domain/usecases/get_trainer_data_usecase.dart';
import 'package:studiosync/modules/trainer/features/profile/domain/usecases/save_trainer_usecase.dart';


class TrainerController extends GetxController {
  final GetCurrentUserIdUseCase _getCurrentUserIdUseCase;
  final GetTrainerDataUseCase _getTrainerDataUseCase;
  final SaveTrainerUseCase _saveTrainerUseCase;
  final PickImageUseCase _pickImageUseCase;
  final LogoutUseCase _logoutUseCase;

  TrainerController(
    this._getCurrentUserIdUseCase,
    this._getTrainerDataUseCase,
    this._saveTrainerUseCase,
    this._logoutUseCase,
    this._pickImageUseCase,
  );

  @override
  onInit() {
    super.onInit();
    getTrainerData();
  }

  Rx<TrainerModel?> trainer = Rx<TrainerModel?>(null);
  final isLoading = false.obs;

  Future<void> getTrainerData() async {
    isLoading.value = true;
    final uid = _getCurrentUserIdUseCase();
    if (uid != null) {
      final trainer = await _getTrainerDataUseCase(uid);
      updateLocalTrainer(trainer!);
    }

    isLoading.value = false;
  }

  void addItemToList<T>(List<T> Function(TrainerModel) getList, T newItem) {
    final trainerModel = trainer.value!;
    final list = getList(trainerModel);
    if (!list.contains(newItem)) {
      list.add(newItem);
      updateLocalTrainer(trainerModel);
      saveTrainerToDb();
    }
  }

  void removeItemFromList<T>(List<T> Function(TrainerModel) getList, T item) {
    final trainerModel = trainer.value!;
    final list = getList(trainerModel);
    if (list.contains(item)) {
      list.remove(item);
      updateLocalTrainer(trainerModel);
      saveTrainerToDb();
    }
  }

  Future<void> addImage() async {
    isLoading.value = true;
    final imgUrl = await _pickImageUseCase(trainer.value!.userId);
    isLoading.value = false;
    if (imgUrl != null) {
      addItemToList((trainer) => trainer.imageUrls!, imgUrl);
    }
  }

  Future<void> setNewProfileImg() async {
    isLoading.value = true;
    final imgUrl = await _pickImageUseCase(trainer.value!.userId);
    isLoading.value = false;
    if (imgUrl != null) {
      updateLocalTrainer(trainer.value!.copyWith(imgUrl: imgUrl));
      saveTrainerToDb();
    }
  }

  void updateLocalTrainer(TrainerModel updatedTrainer) {
    trainer.value = updatedTrainer;
    trainer.refresh();
  }

  void saveTrainerToDb() async {
    isLoading.value = true;
    await _saveTrainerUseCase(trainer.value!);
    isLoading.value = false;
  }

  void logout() async {
    await _logoutUseCase();
    AppRouter.navigateOffAllNamed(Routes.login);
  }
}
