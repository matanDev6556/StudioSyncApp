import 'package:flutter/material.dart';
import 'package:studiosync/core/presentation/utils/validations.dart';
import 'package:studiosync/core/data/models/subscription_model.dart';
import 'package:studiosync/core/presentation/widgets/trainee-profile-tabs/subscription/by_total_sub_widget.dart';

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
      expiredDate: expiredTime ?? expiredDate,
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
  Widget getSubscriptionContainer() {
    return ByTotalSubscriptionContainer(
      subscriptionByTotalTrainings: this,
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
