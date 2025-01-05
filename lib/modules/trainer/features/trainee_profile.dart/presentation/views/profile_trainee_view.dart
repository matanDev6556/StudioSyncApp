import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/core/presentation/utils/dates.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/contollers/trainee_workout_controller.dart';
import 'package:studiosync/core/presentation/widgets/app_bar_profile.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/presentation/views/statistics/statistic_tab.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/presentation/views/subscription/subscription_tab.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/presentation/views/workouts/workouts_tab.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/presentation/views/subscription/widgets/subscription_buttom.dart';


class ProfileOfTraineeView extends GetView<TraineeWorkoutController> {
  final TraineeModel trainee;

  ProfileOfTraineeView({Key? key, required this.trainee}) : super(key: key) {
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

      return DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppStyle.backGrey2,
          body: Column(
            children: [
              AppBarProfileWidget(
                rectangleHeight: 120.h,
                imageUrl: trainee.imgUrl ?? '',
                borderColor: trainee.isActive() ? Colors.green : Colors.red,
              ),
              _buildTraineeHeader(trainee),
              TabBar(
                tabs: const [
                  Tab(text: 'Subscription'),
                  Tab(text: 'Workouts'),
                  Tab(text: 'Statistics'),
                ],
                labelColor: AppStyle.deepBlackOrange,
                unselectedLabelColor: AppStyle.softBrown,
                indicatorColor: AppStyle.softOrange,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SubscriptionTabWidget(
                      trainee: trainee,
                      showBottomAddSubscription: showBottomAddSubscription,
                    ),
                    WorkoutsTabWidget(
                      summary: controller.workoutSummary.value,
                      workouts: controller.workouts,
                      startDate: DatesUtils.getFormattedStartDate(
                        trainee.startWorOutDate,
                      ),
                      showAddWorkoutBottomSheet:
                          controller.showAddWorkoutBottomSheet,
                      deleteWorkout: controller.deleteWorkout,
                    ),
                    StatisticsTabWidget(
                      workouts: controller.workouts,
                      workoutSummary: controller.workoutSummary.value,
                    )
                  ],
                ),
              ),
            ],
          ),
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


}
