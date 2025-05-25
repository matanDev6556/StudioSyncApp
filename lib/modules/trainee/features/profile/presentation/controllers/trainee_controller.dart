import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/domain/usecases/pick_image_usecase.dart';
import 'package:studiosync/core/presentation/router/app_router.dart';
import 'package:studiosync/core/presentation/router/routes.dart';
import 'package:studiosync/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/get_trainee_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/listen_trainee_updates_use_case.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/save_trainee_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

class TraineeController extends GetxController {
  final GetTraineeDataUseCasee _getTraineeDataUseCase;
  final ListenToTraineeUpdatesUseCase _listenToTraineeUpdatesUseCase;
  final SaveTraineeUseCase _saveTraineeUseCase;
  final PickImageUseCase _pickImageUseCase;
  final LogoutUseCase _logoutUseCase;

  TraineeController({
    required GetTraineeDataUseCasee getTraineeDataUseCase,
    required ListenToTraineeUpdatesUseCase listenToTraineeUpdatesUseCase,
    required SaveTraineeUseCase saveTraineeUseCase,
    required PickImageUseCase pickImageUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _getTraineeDataUseCase = getTraineeDataUseCase,
        _listenToTraineeUpdatesUseCase = listenToTraineeUpdatesUseCase,
        _saveTraineeUseCase = saveTraineeUseCase,
        _pickImageUseCase = pickImageUseCase,
        _logoutUseCase = logoutUseCase;

  final isLoading = false.obs;
  Rx<TraineeModel?> trainee = Rx<TraineeModel?>(null);

  StreamSubscription<TraineeModel>? _traineeSubscription;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();

    ever<TraineeModel?>(trainee, (traineeValue) {
      if (traineeValue != null && !_isListeningToTrainee(traineeValue)) {
        _updateTraineePathAndListen();
      }
    });

    getTraineeData();
  }

  @override
  void onClose() {
    print(' trainee controller dispose');
    super.onClose();
    _traineeSubscription?.cancel();
  }

  bool _isListeningToTrainee(TraineeModel traineeValue) {
    return _traineeSubscription != null &&
        !_traineeSubscription!.isPaused &&
        trainee.value?.userId == traineeValue.userId;
  }

  void _updateTraineePathAndListen() {
    debugPrint('Listening to trainee updates');

    _traineeSubscription?.cancel();

    _traineeSubscription =
        _listenToTraineeUpdatesUseCase(trainee.value!).listen(
      (updatedTrainee) {
        updateLocalTrainee(updatedTrainee);
      },
      onError: (error) {
        debugPrint('Error listening to trainee updates: $error');
      },
    );
  }

  Future<void> getTraineeData() async {
    try {
      isLoading.value = true;
      final trainee = await _getTraineeDataUseCase();
      updateLocalTrainee(trainee!);
    } catch (error) {
      debugPrint('Error fetching trainee data: $error');
      // Show an error message or retry option
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfileImage() async {
    isLoading.value = true;

    var imgUrl = await _pickImageUseCase(
      trainee.value!.userId,
    );

    if (imgUrl != null) {
      updateLocalTrainee(trainee.value!.copyWith(imgUrl: imgUrl));
      saveTrainee();
    }
    isLoading.value = true;
  }

  Future<void> saveTrainee() async {
    isLoading.value = true;
    await _saveTraineeUseCase(trainee.value!);
    isLoading.value = false;
  }

  void updateLocalTrainee(TraineeModel traineeModel) {
    trainee.value = traineeModel;
    trainee.refresh();
  }

  void logout() {
    _logoutUseCase.call();
    AppRouter.navigateOffAllNamed(Routes.login);
  }
}
