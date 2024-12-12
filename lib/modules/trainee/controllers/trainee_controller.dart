import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/router/app_touter.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/modules/trainee/features/profile/usecases/listen_trainee_updates_use_case.dart';
import 'package:studiosync/modules/trainee/features/profile/usecases/logout_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/usecases/save_trainee_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/usecases/update_image_usecase.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';

class TraineeController extends GetxController {
  final ListenToTraineeUpdatesUseCase _listenToTraineeUpdatesUseCase;
  final SaveTraineeUseCase _saveTraineeUseCase;
  final UpdateProfileImageUseCase _updateProfileImageUseCase;
  final LogoutUseCase _logoutUseCase;

  TraineeController({
    required ListenToTraineeUpdatesUseCase listenToTraineeUpdatesUseCase,
    required SaveTraineeUseCase saveTraineeUseCase,
    required UpdateProfileImageUseCase updateProfileImageUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _listenToTraineeUpdatesUseCase = listenToTraineeUpdatesUseCase,
        _saveTraineeUseCase = saveTraineeUseCase,
        _updateProfileImageUseCase = updateProfileImageUseCase,
        _logoutUseCase = logoutUseCase;

  final isLoading = false.obs;
  Rx<TraineeModel?> trainee = Rx<TraineeModel?>(null);
  StreamSubscription<TraineeModel>? _traineeSubscription;

  @override
  void onReady() {
    super.onReady();
    _listenToTrainee();
  }

  @override
  void onClose() {
    _traineeSubscription?.cancel();
    super.onClose();
  }

  void _listenToTrainee() {
    final path = _getTraineePath();
    _traineeSubscription = _listenToTraineeUpdatesUseCase
        .execute('$path/${trainee.value!.userId}')
        .listen(
      (updatedTrainee) {
        updateLocalTrainer(updatedTrainee);
      },
      onError: (error) {
        debugPrint("Error listening to trainee updates: $error");
      },
    );
  }

  Future<void> updateProfileImage() async {
    isLoading.value = true;

    await _updateProfileImageUseCase.execute(trainee.value!, _getTraineePath());

    isLoading.value = false;
  }

  Future<void> saveTrainee() async {
    isLoading.value = true;
    await _saveTraineeUseCase.execute(trainee.value!, _getTraineePath());
    isLoading.value = false;
  }

  String _getTraineePath() {
    final trainerId = trainee.value?.trainerID ?? '';
    if (trainerId.isNotEmpty) {
      return 'trainers/$trainerId/trainees';
    } else {
      return 'trainees';
    }
  }

  void updateLocalTrainer(TraineeModel traineeModel) {
    trainee.value = traineeModel;
    trainee.refresh();
  }

  void logout() {
    _logoutUseCase.execute();
    AppRouter.navigateOffAllNamed(Routes.login);
  }
}
