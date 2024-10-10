import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/modules/trainee/models/subscriptions/subscription_model.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/widgets/subscriptions/by_date_sub_widget.dart';

class SubscriptionByDate extends Subscription {
  DateTime startDate;
  DateTime endDate;
  int currentMonth;
  int monthlyTrainingLimit;
  int usedMonthlyTraining;

  SubscriptionByDate({
    required this.startDate,
    required this.endDate,
    required this.monthlyTrainingLimit,
    required this.currentMonth,
    this.usedMonthlyTraining = 0,
    String subscriptionType = 'byDate',
  }) : super(subscriptionType);

  @override
  bool isActive() {
    DateTime currentDate = DateTime.now();
    return currentDate.isAfter(startDate) && currentDate.isBefore(endDate);
  }

  @override
  SubscriptionByDate copyWith({
    DateTime? startDate,
    DateTime? endDate,
    int? monthlyTrainingLimit,
    int? currentMonth,
    int? usedMonthlyTraining,
    String? subscriptionType,
  }) {
    return SubscriptionByDate(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      monthlyTrainingLimit: monthlyTrainingLimit ?? this.monthlyTrainingLimit,
      currentMonth: currentMonth ?? this.currentMonth,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      usedMonthlyTraining: usedMonthlyTraining ?? this.usedMonthlyTraining,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'monthlyTrainingLimit': monthlyTrainingLimit,
      'currentMonth': currentMonth,
      'subscriptionType': subscriptionType,
      'usedMonthlyTraining': usedMonthlyTraining,
    };
  }

  factory SubscriptionByDate.fromJson(Map<String, dynamic> json) {
    return SubscriptionByDate(
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      monthlyTrainingLimit: json['monthlyTrainingLimit'],
      currentMonth: json['currentMonth'],
      subscriptionType: json['subscriptionType'],
      usedMonthlyTraining: json['usedMonthlyTraining'],
    );
  }

  @override
  Widget getSubscriptionContainer({
    required Function editButton,
    bool isTrainer = true,
  }) {
    return ByDateSubscriptionWidget(
      usedMonthlyTraining: usedMonthlyTraining,
      monthlyTrainingLimit: monthlyTrainingLimit,
      currentMonth: currentMonth,
      startDate: startDate,
      endDate: endDate,
      editButton: editButton,
      isActive: isActive,
    );
  }

  @override
  bool isAllowedTosheduleLesson() {
    DateTime currentDate = DateTime.now();

    // Check if the subscription is active
    if (!isActive()) {
      Get.snackbar("", 'Youre subscription are expired!');
      return false;
    }

    // check if the user get to the limit of trainings in this spetsific month
    if (usedMonthlyTraining == monthlyTrainingLimit &&
        currentDate.month == currentMonth) {
      Validations.showValidationSnackBar(
        'you got to the limited training this month',
        Colors.redAccent,
      );
      return false;
    }

    // new month need to reset the monthly limit trainings
    // and need to set new current month
    if (currentDate.month != currentMonth) {
      resetMonthly();
      incrementUsedMonthly();
      return true;
    }

    // menas that usedMonthlyTraining < montlyLimit
    if (usedMonthlyTraining < monthlyTrainingLimit) {
      incrementUsedMonthly();
      return true;
    }

    return true;
  }

  void resetMonthly() {
    usedMonthlyTraining = 0;
    currentMonth = DateTime.now().month;
  }

  void incrementUsedMonthly() {
    usedMonthlyTraining++;
    currentMonth = DateTime.now().month;
  }

  void decrementUsedMonthly() {
    usedMonthlyTraining--;
    currentMonth = DateTime.now().month;
  }

  @override
  void cancleLesson() {
    decrementUsedMonthly();
  }

  @override
  SubscriptionByDate getSub() {
    return this;
  }

  @override
  String toString() {
    return '${super.toString()} SubscriptionByDate{startDate: $startDate\n, endDate: $endDate\n, monthlyTrainingLimit: $monthlyTrainingLimit\n, currentMonth: $currentMonth\n, usedMonthlyTraining: $usedMonthlyTraining\n, subscriptionType: $subscriptionType\n}';
  }
}
