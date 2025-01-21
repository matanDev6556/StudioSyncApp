import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:studiosync/modules/auth/domain/usecases/get_current_useruid_usecase.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/notifications/domain/usecases/approve_trainee_usecase.dart';
import 'package:studiosync/modules/trainer/features/notifications/domain/usecases/listen_to_requests_usecase.dart';
import 'package:studiosync/modules/trainer/features/notifications/domain/usecases/reject_trainee_usecase.dart';

class RequestsController extends GetxController {
  final GetCurrentUserIdUseCase _getCurrentUserIdUseCase;
  final ListenToRequestsUseCase _listenToRequestsUseCase;
  final AproveTraineeUseCase _aproveTraineeUseCase;
  final RejectTraineeUseCase _rejectTraineeUseCase;

  RequestsController({
    required GetCurrentUserIdUseCase getCurrentUserIdUseCase,
    required ListenToRequestsUseCase listenToRequestsUseCase,
    required AproveTraineeUseCase aproveTraineeUseCase,
    required RejectTraineeUseCase rejectTraineeUseCase,
  })  : _getCurrentUserIdUseCase = getCurrentUserIdUseCase,
        _listenToRequestsUseCase = listenToRequestsUseCase,
        _aproveTraineeUseCase = aproveTraineeUseCase,
        _rejectTraineeUseCase = rejectTraineeUseCase;

  RxList<TraineeModel> traineesRequests = <TraineeModel>[].obs;
  final RxBool isLoading = false.obs;

  late StreamSubscription<List<TraineeModel>> requestSubscription;
  late String trainerId;

  @override
  void onInit() {
    super.onInit();
    final uid = _getCurrentUserIdUseCase();
    if (uid != null && uid.isNotEmpty) {
      trainerId = uid;
      requestSubscription = _listenToRequestsUseCase(trainerId).listen(
        (trainees) {
          traineesRequests.value = trainees;
        },
        onError: (error) {
          debugPrint("Error listening to requests: $error");
        },
      );
    } else {
      debugPrint("TrainerController is not ready yet. No trainer ID found.");
    }
  }

  @override
  void onClose() {
    requestSubscription.cancel();
  }

  Future<TraineeModel> approveTraineeRequest(TraineeModel trainee) async {
    isLoading.value = true;
    final updatedTrainee = trainee.copyWith(
      trainerID: trainerId,
      startWorkOutDate: DateTime.now(),
    );

    await _aproveTraineeUseCase(updatedTrainee, trainerId);

    traineesRequests.removeWhere((t) => t.userId == trainee.userId);
    
    isLoading.value = false;

    return updatedTrainee;
  }

  Future<void> rejectTraineeRequest(TraineeModel trainee) async {
    isLoading.value = true;

    await _rejectTraineeUseCase(trainee, trainerId);
    traineesRequests.removeWhere((t) => t.userId == trainee.userId);

    isLoading.value = false;
  }
}
