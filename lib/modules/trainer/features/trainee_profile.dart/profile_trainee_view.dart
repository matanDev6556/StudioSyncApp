import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/core/presentation/utils/dates.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/contollers/subscription_controller.dart';
import 'package:studiosync/core/presentation/widgets/app_bar_profile.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/statistics/statistic_tab.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/subscription/subscription_tab.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/workouts/data/models/workout_model.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/workouts/presentation/views/workouts_tab_view.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/subscription/widgets/subscription_buttom.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/workouts/presentation/workouts_controller.dart';

class ProfileOfTraineeView extends StatelessWidget {
  final TraineeModel trainee;

  ProfileOfTraineeView({Key? key, required this.trainee}) : super(key: key) {
    Get.put(
      SubscriptionController(
          firestoreService: Get.find(),
          initialTrainee: trainee,
          listenToTraineeUpdatesUseCase: Get.find()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final trainee = Get.find<SubscriptionController>().trainee.value;
      final WorkoutsController workoutsController = Get.find();

      workoutsController.fetchWorkouts(trainee!);

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
                unselectedLabelColor: AppStyle.backGrey3,
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
                      summary: workoutsController.workoutSummary.value,
                      workouts: workoutsController.workouts,
                      startDate: DatesUtils.getFormattedStartDate(
                        trainee.startWorOutDate,
                      ),
                      showAddWorkoutBottomSheet: (WorkoutModel? workout) {
                        workoutsController.showAddWorkoutBottomSheet(
                            workout, trainee); // Wrap the function
                      },
                      deleteWorkout: (WorkoutModel workout) {
                        workoutsController.deleteWorkout(
                            trainee, workout); // Wrap it in this function.
                      },
                    ),
                    StatisticsTabWidget(
                      workouts: workoutsController.workouts,
                      workoutSummary: workoutsController.workoutSummary.value,
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
