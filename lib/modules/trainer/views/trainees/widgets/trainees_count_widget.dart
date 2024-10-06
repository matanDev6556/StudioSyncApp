import 'package:flutter/material.dart';
import 'package:studiosync/core/theme/app_style.dart';

class TraineesHeaderWidget extends StatelessWidget {
  final int totalTrainees;

  const TraineesHeaderWidget({required this.totalTrainees, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Trainees: $totalTrainees',
        style:  TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppStyle.deepBlackOrange,
        ),
      ),
    );
  }
}