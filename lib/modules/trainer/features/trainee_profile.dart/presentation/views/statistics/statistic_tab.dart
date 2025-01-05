// statistics_tab_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainee/models/workout_model.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/presentation/views/statistics/widgets/body_summary_card.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/presentation/views/statistics/widgets/weight_section.dart';
import './widgets/workout_summary_card.dart';
import './widgets/section_title.dart';

class StatisticsTabWidget extends StatelessWidget {
  final List<WorkoutModel> workouts;
  final dynamic workoutSummary;

  const StatisticsTabWidget({
    Key? key,
    required this.workouts,
    required this.workoutSummary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Weight'),
          AppStyle.h(10),
          StatisticsSection(
            workouts: workouts,
            weightTrend: workoutSummary.weightTrend,
          ),
          AppStyle.h(10),
          const SectionTitle(title: 'Workouts'),
          WorkoutSummaryCard(summary: workoutSummary),
          const SectionTitle(title: 'Scopes'),
          BodyPartsSummaryCard(
            changes: Map<String, double>.from(workoutSummary.bodyPartChanges),
          ),
        ],
      ),
    );
  }
}
