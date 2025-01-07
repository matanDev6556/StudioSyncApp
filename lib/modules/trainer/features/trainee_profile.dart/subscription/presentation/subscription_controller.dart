import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/router/app_router.dart';
import 'package:studiosync/core/presentation/utils/validations.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_dialog.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/usecases/listen_trainee_updates_use_case.dart';
import 'package:studiosync/core/data/models/by_date_model.dart';
import 'package:studiosync/core/data/models/by_total_trainings_model.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/core/data/models/subscription_model.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/subscription/domain/usecases/cancle_sub_usecase.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/subscription/domain/usecases/save_sub_usecase.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/subscription/presentation/widgets/add_edit_subscription_buttom.dart';

enum SubscriptionType { byDate, byTotalTrainings }

class SubscriptionController extends GetxController {
  final SaveSubscriptionUseCase saveSubscriptionUseCase;
  final CancleSubscriptionUseCase cancleSubscriptionUseCase;
  final ListenToTraineeUpdatesUseCase listenToTraineeUpdatesUseCase;

  SubscriptionController({
    required this.saveSubscriptionUseCase,
    required this.cancleSubscriptionUseCase,
    required this.listenToTraineeUpdatesUseCase,
    required TraineeModel initialTrainee,
  }) {
    trainee.value = initialTrainee;
  }

  @override
  void onInit() {
    super.onInit();
    _listenToTraineeChanges();
  }

  @override
  void onClose() {
    super.onClose();
    traineeDocSubscription.cancel();
  }

  final Rx<TraineeModel?> trainee = Rx<TraineeModel?>(null);
  late StreamSubscription<TraineeModel> traineeDocSubscription;
  // init deafult subs
  var subscriptionByTotal = SubscriptionByTotalTrainings(
    totalTrainings: 0,
    usedTrainings: 0,
  ).obs;

  var subscriptionByDate = SubscriptionByDate(
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 30)),
    monthlyTrainingLimit: 0,
    usedMonthlyTraining: 0,
    currentMonth: DateTime.now().month,
  ).obs;

  var selectedType = SubscriptionType.byDate.obs;

  var isLoading = false.obs;

  //---Shared functions--

  void _listenToTraineeChanges() {
    if (trainee.value != null) {
      traineeDocSubscription =
          listenToTraineeUpdatesUseCase(trainee.value!).listen(
        (updatedTrainee) {
          trainee.value = updatedTrainee;
        },
        onError: (error) {
          debugPrint("Error listening to trainee updates: $error");
        },
      );
    }
  }

  void initSub(
    Subscription? sub,
  ) {
    if (sub == null) return;
    final type = getSubType(sub.subscriptionType);

    if (type == SubscriptionType.byDate) {
      final subscription = sub as SubscriptionByDate;
      subscriptionByDate.value = subscription;
      selectedType.value = SubscriptionType.byDate;
    } else {
      final subscription = sub as SubscriptionByTotalTrainings;
      subscriptionByTotal.value = subscription;
      selectedType.value = SubscriptionType.byTotalTrainings;
    }
  }

  void save(TraineeModel trainee) async {
    try {
      isLoading.value = true;

      TraineeModel updatedTrainee;
      // בדיקה איזה סוג מנוי נבחר ועדכון המודל בהתאם
      if (selectedType.value == SubscriptionType.byDate) {
        updatedTrainee =
            trainee.copyWith(subscription: subscriptionByDate.value);
      } else {
        updatedTrainee =
            trainee.copyWith(subscription: subscriptionByTotal.value);
      }
      await saveSubscriptionUseCase(updatedTrainee);
    } catch (e) {
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    } finally {
      isLoading.value = false;
    }

    AppRouter.navigateBack();
  }

  void cancleSub(TraineeModel trainee) async {
    final TraineeModel updatetrainee = trainee;
    updatetrainee.subscription = null;
    isLoading.value = true;
    await cancleSubscriptionUseCase(updatetrainee);
    isLoading.value = false;
    AppRouter.navigateBack();
  }

  void showSubscriptionButtom(TraineeModel traineeModel, String title) {
    Get.bottomSheet(
      AddSubscriptionWidget(trainee: traineeModel, title: title),
      isScrollControlled: true,
    );
  }
   void showCancelSubscriptionDialog(BuildContext context,TraineeModel traineeModel) {
    showCustomDialog(
      context: context,
      animationPath: 'assets/animations/warning.json',
      title: 'Cancel Subscription',
      msg: 'Are you sure you want to cancel the subscription?',
      doActionMsg: 'Yes, Cancel',
      cancelActionMsg: 'No, Keep',
      onConfirm: () => cancleSub(traineeModel)
    );
  }

  SubscriptionType? getSubType(String subType) {
    switch (subType) {
      case 'byTotalTrainings':
        return SubscriptionType.byTotalTrainings;
      case 'byDate':
        return SubscriptionType.byDate;

      default:
        return null;
    }
  }

  void updateSelectedType(SubscriptionType type) {
    selectedType.value = type;
    selectedType.refresh();
  }

  void updateSubscriptionByTotal(SubscriptionByTotalTrainings newSubscription) {
    subscriptionByTotal.value = newSubscription;
    subscriptionByTotal.refresh();
  }

  void updateSubscriptionByDate(SubscriptionByDate newSubscription) {
    subscriptionByDate.value = newSubscription;
    subscriptionByDate.refresh();
  }

  //----ByTotal functions

  void updateExpredDate(bool isExpired) {
    if (!isExpired) {
      final updatedSub = subscriptionByTotal.value;
      updatedSub.expiredDate = null;

      updateSubscriptionByTotal(updatedSub);
    } else {
      updateSubscriptionByTotal(
          subscriptionByTotal.value.copyWith(expiredTime: DateTime.now()));
    }
  }
}
