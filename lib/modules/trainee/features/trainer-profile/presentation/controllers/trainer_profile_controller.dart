import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/domain/usecases/count_trainees_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/domain/usecases/send_request_usecase.dart';

import 'package:url_launcher/url_launcher.dart';

class TrainerProfileController extends GetxController {
  final CountTraineesOfTrainer _countTraineesOfTrainer;
  final SendRequestUseCase _sendRequestUseCase;

  final TraineeController traineeController = Get.find();

  TrainerProfileController({
    required CountTraineesOfTrainer countTraineesOfTrainer,
    required SendRequestUseCase sendRequestUseCase,
  })  : _countTraineesOfTrainer = countTraineesOfTrainer,
        _sendRequestUseCase = sendRequestUseCase;

  final isLoading = false.obs;

  Future<void> sendRequest(
    String trainerID,
    TraineeModel traineeModel,
  ) async {
    try {
      await _sendRequestUseCase.execute(traineeModel, trainerID);
      Validations.showValidationSnackBar(
          'Sent request successfully', Colors.green);
    } catch (e) {
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<int> countTraineesOfTrainer(String trainerID) async {
    return _countTraineesOfTrainer.execute(trainerID);
  }

  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
