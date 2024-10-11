import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/modules/trainee/models/subscriptions/by_date_model.dart';
import 'package:studiosync/modules/trainee/models/subscriptions/by_total_trainings_model.dart';
import 'package:studiosync/modules/trainee/models/subscriptions/subscription_model.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';


enum SubscriptionType { byDate, byTotalTrainings }

class SubscriptionController extends GetxController {
  final FirestoreService firestoreService;

  SubscriptionController(this.firestoreService);

  

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

  void save(TraineeModel trainee) async {
    try {
      isLoading.value = true;
      if (selectedType.value == SubscriptionType.byDate) {
        await firestoreService.updateDocument(
          'users',
          trainee.userId,
          trainee.copyWith(subscription: subscriptionByDate.value).toMap(),
        );
      } else {
        await firestoreService.updateDocument(
          'users',
          trainee.userId,
          trainee.copyWith(subscription: subscriptionByTotal.value).toMap(),
        );
      }
    } catch (e) {
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    } finally {
      isLoading.value = false;
    }

    Get.back();
  }

  void cancleSub(TraineeModel trainee) async {
    final TraineeModel updatetrainee = trainee;
    updatetrainee.subscription = null;
    isLoading.value = true;
    await firestoreService.updateDocument(
      'users',
      trainee.userId,
      updatetrainee.toMap(),
    );
    isLoading.value = false;
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
