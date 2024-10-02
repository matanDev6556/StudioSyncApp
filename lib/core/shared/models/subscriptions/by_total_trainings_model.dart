import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/core/shared/models/subscriptions/subscription_model.dart';
import 'package:studiosync/core/shared/widgets/linear_progress.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$usedTrainings / $totalTrainings Workouts',
                style: TextStyle(
                  color: AppStyle.deepBlackOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const Spacer(),
              expiredDate != null
                  ? Text(
                      'Expired at : ${DateFormat('dd-MM-yy').format(expiredDate!)}',
                      style: TextStyle(color: AppStyle.backGrey3),
                    )
                  : const SizedBox(),
            ],
          ),
          LinearProgressWorkOuts(
            isActive: isActive(),
            isTrainer: isTrainer,
            howWorkOutsDid: isActive() ? usedTrainings : 1,
            totalWorkouts: isActive() ? totalTrainings : 1,
            editButton: () => editButton(),
          ),
        ],
      ),
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
