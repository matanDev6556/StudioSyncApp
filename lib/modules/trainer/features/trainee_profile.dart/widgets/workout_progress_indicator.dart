import 'package:flutter/material.dart';
import 'package:studiosync/core/theme/app_style.dart';

class WorkoutProgressIndicator extends StatelessWidget {
  const WorkoutProgressIndicator({
    super.key,
    required this.totalWorkoutCount,
    required this.completedWorkouts,
    required this.showEditButton,
    required this.isActive,
    this.onEditPressed,
  });

  final int totalWorkoutCount;
  final int completedWorkouts;
  final bool showEditButton;
  final bool isActive;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showEditButton)
          IconButton(
            onPressed: onEditPressed,
            icon: Icon(
              Icons.edit,
              color: AppStyle.backGrey3,
            ),
          ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: LinearProgressIndicator(
              minHeight: 20,
              value: (totalWorkoutCount > 0)
                  ? completedWorkouts / totalWorkoutCount
                  : 0.0,
              backgroundColor: AppStyle.backGrey2,
              valueColor: AlwaysStoppedAnimation<Color>(AppStyle.softOrange),
            ),
          ),
        ),
        AppStyle.w(15),
        CircleAvatar(
          radius: 7,
          backgroundColor: isActive ? Colors.greenAccent : Colors.redAccent,
        ),
      ],
    );
  }
}
