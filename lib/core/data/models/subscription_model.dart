import 'package:flutter/material.dart';

abstract class Subscription {
  final String subscriptionType;

  const Subscription(this.subscriptionType);

  bool isActive();
  bool isAllowedTosheduleLesson();
  void cancleLesson();
  void joinLesson();
  Widget getSubscriptionContainer();

  Subscription copyWith();
  Map<String, dynamic> toMap();
}
