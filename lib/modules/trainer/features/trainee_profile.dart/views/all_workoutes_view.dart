import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainee/models/workout_model.dart';
import 'package:studiosync/modules/trainer/contollers/trainee_workout_controller.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/widgets/single_workout_card.dart';

import 'package:studiosync/shared/widgets/custom_container.dart';

class AllWorkoutsView extends GetView<TraineeWorkoutController> {
  const AllWorkoutsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backGrey2,
      appBar: AppBar(
        title: Text(
          'Workout History',
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
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: AppStyle.softOrange),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(() => _buildSummaryCard(controller.workouts)),
          Obx(() => _buildWorkoutList()),
        ],
      ),
    );
  }

  Widget _buildWorkoutList() {
    return controller.workouts.isEmpty
        ? _buildEmptyState()
        : Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: controller.workouts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: SingleWorkoutWidget(
                    workout: controller.workouts[index],
                    onDelete: (workout) {
                      controller.deleteWorkout(workout);
                    },
                    onEdit: (workout) {
                      controller.showAddWorkoutBottomSheet(workout);
                    },
                  ),
                );
              },
            ),
          );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        SizedBox(
          height: Get.height * 0.5,
          child: SvgPicture.asset(
            'assets/images/workout.svg',
            width: 250.w,
          ),
        ),
        const Center(
          child: CustomContainer(
            text: 'No workouts yet!',
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(List<WorkoutModel> workouts) {
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
          Text(
            'Workout Summary',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppStyle.softBrown,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('Total Workouts', workouts.length.toString()),
              _buildSummaryItem(
                'Min weight',
                controller.workoutSummary.value.minWeight.toString(),
              ),
              _buildSummaryItem(
                'Last Workout',
                controller.workoutSummary.value.daysSinceLastWorkout.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
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
            color: AppStyle.softOrange,
          ),
        ),
      ],
    );
  }
}
