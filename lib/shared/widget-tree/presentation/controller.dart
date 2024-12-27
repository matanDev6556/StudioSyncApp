import 'package:get/get.dart';
import 'package:studiosync/core/domain/usecases/pick_image_usecase.dart';
import 'package:studiosync/core/router/app_router.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/features/profile/data/repositories/firestore_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/listen_trainee_updates_use_case.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/save_trainee_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_controller.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';
import 'package:studiosync/core/data/models/user_model.dart';
import 'package:studiosync/shared/widget-tree/domain/usecases/check_role_usecase.dart';
import 'package:studiosync/shared/widget-tree/domain/usecases/get_trainee_usecase.dart';
import 'package:studiosync/shared/widget-tree/domain/usecases/get_trainer_usecase.dart';

class WidgetTreeController<T extends UserModel> extends GetxController {
  final CheckUserRoleUseCase _checkUserRoleUseCase;
  final GetTraineeDataUseCase _getTraineeDataUseCase;
  final GetTrainerDataUseCase _getTrainerDataUseCase;
  final IAuthRepository _iAuthRepository;

  WidgetTreeController({
    required CheckUserRoleUseCase checkUserRoleUseCase,
    required GetTraineeDataUseCase getTraineeDataUseCase,
    required GetTrainerDataUseCase getTrainerDataUseCase,
    required IAuthRepository iAuthRepository,
  })  : _checkUserRoleUseCase = checkUserRoleUseCase,
        _getTraineeDataUseCase = getTraineeDataUseCase,
        _getTrainerDataUseCase = getTrainerDataUseCase,
        _iAuthRepository = iAuthRepository;

  var userModel = Rxn<UserModel>();
  final isLoading = false.obs;

  Future<void> chckUserAndRedirect() async {
    final currentUser = _iAuthRepository.currentUser;
    final uid = currentUser.uid;

    if (currentUser == null) {
      AppRouter.navigateTo(Routes.login);
      return;
    }

    // check user role
    String? userRole = await _checkUserRoleUseCase(uid);

    if (userRole == null) {
      AppRouter.navigateOffAllNamed(Routes.signUpAs);
      return;
    }

    if (userRole == 'trainee') {
      TraineeModel? traineeModel = await _getTraineeDataUseCase(uid);
      userModel.value = traineeModel;
      _applyTraineeDependency(traineeModel);
    } else if (userRole == 'trainer') {
      TrainerModel? trainerModel = await _getTrainerDataUseCase(uid);
      userModel.value = trainerModel;
      _applyTrainerDependency(trainerModel);
    }
  }

  _applyTraineeDependency(TraineeModel? traineeModel) {
    final traineeRepository =
        FirestoreTraineeRepository(Get.find<FirestoreService>());

    Get.put<TraineeController>(
      TraineeController(
        listenToTraineeUpdatesUseCase:
            Get.put(ListenToTraineeUpdatesUseCase(traineeRepository)),
        saveTraineeUseCase: Get.put(SaveTraineeUseCase(traineeRepository)),
        pickImageUseCase: Get.find<PickImageUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
      ),
      permanent: true,
    ).trainee.value = traineeModel;

    AppRouter.navigateOffAllNamed(Routes.homeTrainee);
  }

  _applyTrainerDependency(TrainerModel? trainerModel) {
    Get.put(
            TrainerController(
              Get.find(),
              Get.find(),
              Get.find(),
            ),
            permanent: true)
        .trainer
        .value = trainerModel;
    AppRouter.navigateOffAllNamed(Routes.homeTrainer);
  }
}
