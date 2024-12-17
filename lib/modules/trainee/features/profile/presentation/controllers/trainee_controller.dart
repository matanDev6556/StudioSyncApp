import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/domain/usecases/pick_image_usecase.dart';
import 'package:studiosync/core/router/app_touter.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/listen_trainee_updates_use_case.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/save_trainee_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

class TraineeController extends GetxController {

  final ListenToTraineeUpdatesUseCase _listenToTraineeUpdatesUseCase;
  final SaveTraineeUseCase _saveTraineeUseCase;
  final PickImageUseCase _pickImageUseCase;
  final LogoutUseCase _logoutUseCase;

  TraineeController({
    
    required ListenToTraineeUpdatesUseCase listenToTraineeUpdatesUseCase,
    required SaveTraineeUseCase saveTraineeUseCase,
    required PickImageUseCase pickImageUseCase,
    required LogoutUseCase logoutUseCase,
  })  : 
        _listenToTraineeUpdatesUseCase = listenToTraineeUpdatesUseCase,
        _saveTraineeUseCase = saveTraineeUseCase,
        _pickImageUseCase = pickImageUseCase,
        _logoutUseCase = logoutUseCase;

  final isLoading = false.obs;
  Rx<TraineeModel?> trainee = Rx<TraineeModel?>(null);

  StreamSubscription<TraineeModel>? _traineeSubscription;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onReady() {
    super.onReady();
    _updateTraineePathAndListen();
    
  }

  @override
  void onClose() {
    _traineeSubscription?.cancel();
    super.onClose();
  }


  void _updateTraineePathAndListen() {
    // 1. ביטול האזנה קודמת (אם קיימת)
    _traineeSubscription?.cancel();

    // 2. קבלת הנתיב החדש
    final path = _getTraineePath();

    // 3. האזנה לנתיב החדש
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

    var imgUrl = await _pickImageUseCase.execute(
      trainee.value!.userId,
    );

    updateLocalTrainer(trainee.value!.copyWith(imgUrl: imgUrl));
    saveTrainee();
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
    _logoutUseCase.call();
    AppRouter.navigateOffAllNamed(Routes.login);
  }
}
