// workout_summary_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/statistics/widgets/summary_item.dart';

class WorkoutSummaryCard extends StatelessWidget {
  final dynamic summary;

  const WorkoutSummaryCard({
    Key? key,
    required this.summary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: AppStyle.boxShadow,
      ),
      child: Column(
        children: [
          _buildSummaryRow([
            SummaryItem(
              label: 'Avg Weight',
              value: '${summary.minWeight.toStringAsFixed(1)} Kg',
              icon: Icons.balance,
            ),
            SummaryItem(
              label: 'Last Workout',
              value: summary.daysSinceLastWorkout,
              icon: Icons.calendar_today,
            ),
          ]),
          SizedBox(height: 25.h),
          _buildSummaryRow([
            SummaryItem(
              label: 'Total Workouts',
              value: summary.totalWorkouts.toString(),
              icon: Icons.fitness_center,
            ),
            SummaryItem(
              label: 'Min Weight',
              value: '${summary.minWeight.toStringAsFixed(1)} Kg',
              icon: Icons.arrow_downward,
            ),
            SummaryItem(
              label: 'Max Weight',
              value: '${summary.maxWeight.toStringAsFixed(1)} Kg',
              icon: Icons.arrow_upward,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(List<Widget> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items,
    );
  }
}