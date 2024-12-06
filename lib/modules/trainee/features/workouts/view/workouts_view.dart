import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/core/utils/dates.dart';
import 'package:studiosync/modules/trainee/controllers/workouts_controller.dart';
import 'package:studiosync/modules/trainee/models/subscriptions/subscription_model.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/widgets/data_workout_container.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/widgets/msg_statistic.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/widgets/workouts_list.dart';
import 'package:studiosync/shared/widgets/custom_container.dart';

class WorkoutsView extends GetView<WorkoutController> {
  const WorkoutsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.all(16.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleText('Subscription'),
              AppStyle.h(10.h),
              _buildSubscriptionSection(controller.getSubscription().value),
              AppStyle.h(15.h),
              titleText('Start At'),
              AppStyle.h(10.h),
              _buildStartAtSection(),
              AppStyle.h(10.h),
              _buildStatisticsSection(),
              AppStyle.h(15.h),
              _buildWorkoutSection(),
            ],
          ),
        ),
      );
    });
  }

  Text titleText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppStyle.softBrown,
        fontWeight: FontWeight.w600,
        fontSize: 17.sp,
      ),
    );
  }

  Widget _buildSubscriptionSection(Subscription? subscription) {
    return subscription != null
        ? subscription.getSubscriptionContainer(isTrainer: false)
        : CustomContainer(
            text: 'Talk with your trainer for set subscription!',
            padding: EdgeInsets.all(15.h),
            backgroundColor: Colors.red.withOpacity(0.2),
            textColor: Color.fromARGB(221, 62, 62, 62),
            width: Get.width,
          );
  }

  Widget _buildStartAtSection() {
    return WorkOutDataContainer(
      traineeDataWorkout: DatesUtils.getFormattedStartDate(
          controller.trainee.value?.startWorOutDate),
      emptyDataReplace: 'Not started yet',
      iconPath: 'assets/icons/clock_icon.png',
    );
  }

  Widget _buildWorkoutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            titleText('Workouts'),
            const Spacer(),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 22.h,
                color: AppStyle.deepBlackOrange,
              ),
              onPressed: () => Get.toNamed(
                Routes.allTraineeWorkouts,
                arguments: {
                  'workouts': controller.workouts,
                  'summary': controller.workoutSummary.value
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        controller.workouts.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: CustomContainer(
                    text: 'No workouts yet!',
                  ),
                ),
              )
            : WorkoutHorizontalListCard(
                workouts: controller.workouts,
              ),
      ],
    );
  }

  Widget _buildStatisticsSection() {
    if (controller.workouts.length < 2) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            titleText('Statistics'),
            const Spacer(),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 22.h,
                color: AppStyle.deepBlackOrange,
              ),
              onPressed: () => Get.toNamed(Routes.workoutsAnalytic,
                  arguments: controller.workoutSummary.value),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        WeightTrendMessageWidget(
          controller.workoutSummary.value.weightTrend,
        ),
      ],
    );
  }
}
