import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/core/presentation/utils/dates.dart';
import 'package:studiosync/core/presentation/views/trainee-profile-tabs/statistic_tab_view.dart';
import 'package:studiosync/core/presentation/views/trainee-profile-tabs/subscription_tab_view.dart';
import 'package:studiosync/core/presentation/views/trainee-profile-tabs/workouts_tab_view.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_container.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/trainee-sections/workouts_controller.dart';

class TraineeSectionsView extends StatelessWidget {
  const TraineeSectionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final WorkoutTraineeController workoutTraineeController = Get.find();
      final trainee = Get.find<TraineeController>().trainee.value;

      return DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppStyle.backGrey2,
          body: Column(
            children: [
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
                      trainee: trainee!,
                    ),
                    trainee.subscription != null
                        ? WorkoutsTabWidget(
                            isTrainer: true,
                            summary:
                                workoutTraineeController.workoutSummary.value,
                            workouts: workoutTraineeController.workouts,
                            startDate: DatesUtils.getFormattedStartDate(
                              trainee.startWorOutDate,
                            ),
                          )
                        : Center(
                            child: CustomContainer(
                              textColor: AppStyle.darkGrey,
                              padding: EdgeInsets.symmetric(
                                  vertical: 16.sp, horizontal: 16.sp),
                              text: 'No subscription sets',
                              backgroundColor:
                                  Colors.redAccent.withOpacity(0.3),
                            ),
                          ),
                    StatisticsTabWidget(
                      workouts: workoutTraineeController.workouts,
                      workoutSummary:
                          workoutTraineeController.workoutSummary.value,
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
}
