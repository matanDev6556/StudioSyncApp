import 'package:flutter/material.dart';

abstract class Subscription {
  final String subscriptionType;
  const Subscription(this.subscriptionType);

  bool isActive();
  bool isAllowedTosheduleLesson();
  Widget getSubscriptionContainer();
  void cancleLesson();
  Subscription getSub();

  Subscription copyWith();
  Map<String, dynamic> toMap();

  @override
  String toString() {
    return 'Type: $subscriptionType';
  }
}
