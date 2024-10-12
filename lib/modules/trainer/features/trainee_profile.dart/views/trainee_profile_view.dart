import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/models/workout_model.dart';
import 'package:studiosync/modules/trainer/contollers/trainee_workout_controller.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/widgets/app_bar_trainee.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/widgets/data_workout_container.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/widgets/msg_statistic.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/widgets/subscriptions/subscription_buttom.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/widgets/workouts_list.dart';
import 'package:studiosync/shared/widgets/custom_container.dart';
import 'package:studiosync/shared/widgets/custome_bttn.dart';

class TraineeProfileView extends GetView<TraineeWorkoutController> {
  final TraineeModel trainee;

  TraineeProfileView({Key? key, required this.trainee}) : super(key: key) {
    // create controller for this view
    Get.put(
      TraineeWorkoutController(
        initialTrainee: trainee,
        traineeProfileService: Get.find(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final trainee = controller.trainee.value!;

      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppStyle.backGrey2,
        floatingActionButton: FloatingActionButton(
          onPressed: () => controller.showAddWorkoutBottomSheet(null),
          backgroundColor: AppStyle.softOrange,
          child: Icon(Icons.add, color: AppStyle.darkOrange),
        ),
        body: Column(
          children: [
            AppBarTraineeWidget(
              rectangleHeight: 120.h,
              trainee: trainee,
            ),
            _buildTraineeHeader(trainee),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Subscription'),
                      _buildSubscriptionSection(trainee),
                      SizedBox(height: 25.h),
                      _buildStatisticsSection(controller.workouts),
                      SizedBox(height: 20.h),
                      _buildStartAtSection(),
                      SizedBox(height: 20.h),
                      _buildWorkoutSection(controller.workouts),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTraineeHeader(TraineeModel trainee) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            trainee.userFullName,
            style: TextStyle(
              color: AppStyle.deepBlackOrange,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.phone, color: AppStyle.deepBlackOrange),
          )
        ],
      ),
    );
  }

  Widget _buildSubscriptionSection(TraineeModel trainee) {
    return trainee.subscription != null
        ? trainee.subscription!.getSubscriptionContainer(
            editButton: () {
              showBottomAddSubscription(
                Get.context!,
                trainee,
              );
            },
          )
        : CustomButton(
            fontSize: 22.sp,
            text: 'Add subscription',
            fill: true,
            color: Colors.redAccent.withOpacity(0.5),
            width: Get.width,
            height: 50.h,
            onTap: () {
              showBottomAddSubscription(Get.context!, trainee, title: 'Add');
            },
          );
  }

  Widget _buildStatisticsSection(List<WorkoutModel> workouts) {
    if (workouts.length < 2) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Statistics'),
        SizedBox(height: 5.h),
        WeightTrendMessageWidget(
            controller.getWeightTrendMessage(controller.workouts)),
      ],
    );
  }

  Widget _buildStartAtSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Start At'),
        SizedBox(height: 5.h),
        WorkOutDataContainer(
          traineeDataWorkout: controller.getFormattedStartDate(),
          emptyDataReplace: 'Not started yet',
          iconPath: 'assets/icons/clock_icon.png',
        ),
      ],
    );
  }

  Widget _buildWorkoutSection(List<WorkoutModel> workouts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _sectionTitle('Workouts'),
            const Spacer(),
            InkWell(
              onTap: () => Get.toNamed(Routes.allTraineeWorkouts),
              child: Container(
                width: 100.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: AppStyle.softOrange,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: AppStyle.deepBlackOrange,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        workouts.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: CustomContainer(
                    text: 'No workouts yet!',
                  ),
                ),
              )
            : WorkoutHorizontalListCard(
                workouts: workouts,
                onDelete: (workout) {
                  controller.deleteWorkout(workout);
                },
                onEdit: (workout) =>
                    controller.showAddWorkoutBottomSheet(workout),
              ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Text(
        text,
        style: TextStyle(
          color: AppStyle.deepBlackOrange,
          fontWeight: FontWeight.bold,
          fontSize: 17.sp,
        ),
      ),
    );
  }
}
