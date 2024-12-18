import 'package:get/get.dart';
import 'package:studiosync/core/router/app_router.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/bindings/trainee_binding.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_controller.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';
import 'package:studiosync/shared/models/user_model.dart';
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
    TraineeBinding().dependencies();
    Get.find<TraineeController>().trainee.value = traineeModel;
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
