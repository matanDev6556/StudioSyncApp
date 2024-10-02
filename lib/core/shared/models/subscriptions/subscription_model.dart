import 'package:flutter/material.dart';

abstract class Subscription {
  final String subscriptionType;

  const Subscription(this.subscriptionType);

  bool isActive();
  bool isAllowedTosheduleLesson();
  Subscription copyWith();
  Map<String, dynamic> toMap();
  Widget getSubscriptionContainer(
      {required Function editButton, bool isTrainer = true});

  @override
  String toString() {
    return 'Type: $subscriptionType';
  }

  void cancleLesson();

  Subscription getSub();
}
