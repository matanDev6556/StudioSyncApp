import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainer/contollers/trainee_workout_controller.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/widgets/msg_statistic.dart';

class WorkoutAnalyticView extends GetView<TraineeWorkoutController> {
  const WorkoutAnalyticView({Key? key}) : super(key: key);

  static EdgeInsets get commonPadding =>
      EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.h);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backGrey2,
      appBar: _buildAppBar(),
      body: Obx(() => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Weight Process'),
                WeightTrendMessageWidget(
                  controller.workoutSummary.value.weightTrend,
                ),
                _buildSectionTitle('Workouts Summary'),
                _buildSummaryCard(),
                _buildSectionTitle('Body scopes'),
                _buildBodyPartChangeSummary(controller
                    .workoutSummary.value.bodyPartChanges
                    .map((key, value) => MapEntry(key, value.toDouble()))),
              ],
            ),
          )),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Workout Analytics', style: AppStyle.titleStyle),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: _buildIconButton(Icons.arrow_back_ios, () => Get.back()),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: AppStyle.softOrange),
      onPressed: onPressed,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: commonPadding,
      child: Text(
        title,
        style: AppStyle.sectionTitleStyle,
      ),
    );
  }

  Widget _buildSummaryCard() {
    final summary = controller.workoutSummary.value;
    return _buildCard(
      child: Column(
        children: [
          _buildSummaryRow([
            _buildSummaryItem('Avg Weight',
                '${summary.minWeight.toStringAsFixed(1)} Kg', Icons.balance),
            _buildSummaryItem('Last Workout', summary.daysSinceLastWorkout,
                Icons.calendar_today),
          ]),
          SizedBox(height: 25.h),
          _buildSummaryRow([
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

  Widget _buildCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: AppStyle.boxShadow,
      ),
      child: child,
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppStyle.softOrange, size: 24.sp),
        SizedBox(height: 8.h),
        Text(label, style: AppStyle.summaryLabelStyle),
        SizedBox(height: 4.h),
        Text(value, style: AppStyle.softValueStyle),
      ],
    );
  }

  Widget _buildBodyPartChangeSummary(Map<String, double> changes) {
    if (changes.isEmpty) {
      return _buildCard(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            "Not enough data to show progress.",
            style: AppStyle.bodyTextStyle,
          ),
        ),
      );
    }

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: changes.entries
            .map((entry) => _buildBodyPartChangeItem(entry.key, entry.value))
            .toList(),
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
          Text(bodyPart, style: AppStyle.bodyTextStyle),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: changeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(changeText, style: TextStyle(color: changeColor)),
          ),
        ],
      ),
    );
  }
}
