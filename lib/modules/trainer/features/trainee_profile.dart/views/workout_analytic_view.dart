import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainer/contollers/trainee_workout_controller.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/widgets/msg_statistic.dart';

class WorkoutAnalyticView extends GetView<TraineeWorkoutController> {
  const WorkoutAnalyticView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: AppStyle.backGrey2,
        appBar: AppBar(
          title: Text(
            'Workout Analytics',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppStyle.deepBlackOrange,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppStyle.softOrange),
            onPressed: () => Get.back(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h),
                child: Text(
                  'Weight Process',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppStyle.softBrown,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              WeightTrendMessageWidget(
                  controller.workoutSummary.value.weightTrend),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h),
                child: Text(
                  'Workouts Summary',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppStyle.softBrown,
                  ),
                ),
              ),
              _buildSummaryCard(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h),
                child: Text(
                  'Body scopes',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppStyle.softBrown,
                  ),
                ),
              ),
              _buildBodyPartChangeSummary(controller
                  .workoutSummary.value.bodyPartChanges
                  .map((key, value) => MapEntry(key, value.toDouble()))),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSummaryCard() {
    final summary = controller.workoutSummary.value;
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('Avg Weight',
                  '${summary.minWeight.toStringAsFixed(1)} Kg', Icons.balance),
              _buildSummaryItem('Last Workout', summary.daysSinceLastWorkout,
                  Icons.calendar_today),
            ],
          ),
          SizedBox(height: 25.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('Total Workouts',
                  summary.totalWorkouts.toString(), Icons.fitness_center),
              _buildSummaryItem(
                  'Min Weight',
                  '${summary.minWeight.toStringAsFixed(1)} Kg',
                  Icons.arrow_downward),
              _buildSummaryItem(
                  'Max Weight',
                  '${summary.maxWeight.toStringAsFixed(1)} Kg',
                  Icons.arrow_upward),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppStyle.softOrange, size: 24.sp),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppStyle.backGrey3,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppStyle.deepBlackOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildBodyPartChangeSummary(Map<String, double> changes) {
    if (changes.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Text(
          "Not enough data to show progress.",
          style: TextStyle(
            fontSize: 16.sp,
            color: AppStyle.backGrey3,
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...changes.entries
              .map((entry) => _buildBodyPartChangeItem(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildBodyPartChangeItem(String bodyPart, double change) {
    Color changeColor = change > 0
        ? Colors.green
        : (change < 0 ? Colors.red : AppStyle.backGrey3);
    String changeText = change == 0
        ? 'No change'
        : '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)}%';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            bodyPart,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppStyle.backGrey3,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: changeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              changeText,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: changeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
