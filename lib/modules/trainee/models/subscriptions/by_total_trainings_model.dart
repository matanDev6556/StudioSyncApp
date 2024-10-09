import 'package:flutter/material.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/modules/trainee/models/subscriptions/subscription_model.dart';
import 'package:studiosync/modules/trainer/views/trainee_profile.dart/widgets/subscriptions/by_total_sub_widget.dart';

class SubscriptionByTotalTrainings extends Subscription {
  int totalTrainings;
  int usedTrainings;
  DateTime? expiredDate;

  SubscriptionByTotalTrainings({
    required this.totalTrainings,
    required this.usedTrainings,
    this.expiredDate,
    String subscriptionType = 'byTotalTrainings',
  }) : super(subscriptionType);

  @override
  bool isActive() {
    if (expiredDate != null) {
      return usedTrainings < totalTrainings &&
          DateTime.now().isBefore(expiredDate!);
    }
    return usedTrainings < totalTrainings;
  }

  @override
  SubscriptionByTotalTrainings copyWith({
    int? totalTrainings,
    int? usedTrainings,
    String? subscriptionType,
    DateTime? expiredTime,
  }) {
    return SubscriptionByTotalTrainings(
      totalTrainings: totalTrainings ?? this.totalTrainings,
      usedTrainings: usedTrainings ?? this.usedTrainings,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      expiredDate: expiredTime ?? this.expiredDate,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'totalTrainings': totalTrainings,
      'usedTrainings': usedTrainings,
      'subscriptionType': subscriptionType,
      'expiredDate': expiredDate?.toIso8601String(),
    };
  }

  factory SubscriptionByTotalTrainings.fromJson(Map<String, dynamic> json) {
    return SubscriptionByTotalTrainings(
      totalTrainings: json['totalTrainings'],
      usedTrainings: json['usedTrainings'],
      subscriptionType: json['subscriptionType'],
      expiredDate: json['expiredDate'] != null
          ? DateTime.parse(json['expiredDate'])
          : null,
    );
  }

  @override
  Widget getSubscriptionContainer(
      {required Function editButton, bool isTrainer = true}) {
    return ByTotalSubscriptionContainer(
      expiredDate: expiredDate,
      usedTrainings: usedTrainings,
      totalTrainings: totalTrainings,
      editButton: editButton,
      isActive: isActive(),
      isTrainer: isTrainer,
    );
  }

  @override
  bool isAllowedTosheduleLesson() {
    if (!isActive()) {
      Validations.showValidationSnackBar(
        'Youre subscription expired!,contact with youre trainer',
        Colors.redAccent,
      );
      return false;
    }

    incrementUsedTrainings();
    return true;
  }

  void incrementUsedTrainings() {
    usedTrainings++;
  }

  void decrementUsedTrainings() {
    usedTrainings--;
  }

  @override
  void cancleLesson() {
    decrementUsedTrainings();
  }

  @override
  Subscription getSub() {
    return this;
  }
}

class SubscriptionContainer {}
