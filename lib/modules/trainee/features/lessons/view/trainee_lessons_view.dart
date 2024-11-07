import 'package:flutter/material.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/days_selector.dart';

class LessonsTraineeView extends StatelessWidget {
  const LessonsTraineeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeekDaysSelector(selectedDayIndex: 1, onDaySelected: (index) {}),
      ],
    );
  }
}
