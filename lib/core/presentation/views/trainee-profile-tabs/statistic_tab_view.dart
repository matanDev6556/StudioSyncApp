// statistics_tab_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_container.dart';
import 'package:studiosync/core/data/models/workout_model.dart';
import 'package:studiosync/core/presentation/widgets/trainee-profile-tabs/statistics/body_summary_card.dart';
import 'package:studiosync/core/presentation/widgets/trainee-profile-tabs/statistics/weight_section.dart';
import '../../widgets/trainee-profile-tabs/statistics/workout_summary_card.dart';
import '../../widgets/general/section_title.dart';

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
          Row(
            children: [
              CustomContainer(
                child: Icon(
                  Icons.monitor_weight_outlined,
                  color: AppStyle.softOrange,
                ),
              ),
              const SectionTitle(title: 'Weight'),
            ],
          ),
          AppStyle.h(10),
          StatisticsSection(
            workouts: workouts,
            weightTrend: workoutSummary.weightTrend,
          ),
          AppStyle.h(10),
          Row(
            children: [
              CustomContainer(
                child: Icon(
                  Icons.fitness_center_outlined,
                  color: AppStyle.softOrange,
                ),
              ),
              const SectionTitle(title: 'Workouts'),
            ],
          ),
          WorkoutSummaryCard(summary: workoutSummary),
          Row(
            children: [
              CustomContainer(
                  child: Image.asset(
                'assets/icons/measure-1-svgrepo-com.png',
                width: 28.w,
              )),
              const SectionTitle(title: 'Scopes'),
            ],
          ),
          BodyPartsSummaryCard(
            changes: Map<String, double>.from(workoutSummary.bodyPartChanges),
          ),
        ],
      ),
    );
  }
}
