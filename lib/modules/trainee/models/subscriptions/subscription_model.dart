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


  void cancleLesson();

  Subscription getSub();

   @override
  String toString() {
    return 'Type: $subscriptionType';
  }

}
