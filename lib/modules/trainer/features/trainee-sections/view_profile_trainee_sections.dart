import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/core/presentation/utils/dates.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_container.dart';
import 'package:studiosync/core/presentation/widgets/general/custome_bttn.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/trainee-sections/subscription/presentation/subscription_controller.dart';
import 'package:studiosync/core/presentation/widgets/general/app_bar_profile.dart';
import 'package:studiosync/core/presentation/views/trainee-sections/statistic_tab_view.dart';
import 'package:studiosync/core/presentation/views/trainee-sections/subscription_tab_view.dart';
import 'package:studiosync/modules/workouts/data/model/workout_model.dart';
import 'package:studiosync/modules/workouts/presentation/views/workouts_tab_view.dart';
import 'package:studiosync/modules/trainer/features/trainee-sections/workouts/presentation/workouts_controller.dart';

class ProfileOfTraineeView extends StatelessWidget {
  final TraineeModel trainee;

  ProfileOfTraineeView({Key? key, required this.trainee}) : super(key: key) {
    Get.put(
      SubscriptionController(
        saveSubscriptionUseCase: Get.find(),
        cancleSubscriptionUseCase: Get.find(),
        initialTrainee: trainee,
        listenToTraineeUpdatesUseCase: Get.find(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final trainee = Get.find<SubscriptionController>().trainee.value;
      final WorkoutsController workoutsController = Get.find();
      final SubscriptionController subscriptionController = Get.find();

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
                    trainee.subscription != null
                        ? SubscriptionTabWidget(
                            trainee: trainee,
                            actions: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildActionButton(
                                  context,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                  color: AppStyle.softOrange,
                                  onPressed: () => subscriptionController
                                      .showSubscriptionButtom(trainee, 'Edit'),
                                ),
                                _buildActionButton(
                                  context,
                                  icon: Icons.cancel,
                                  label: 'Cancel',
                                  color: Colors.redAccent,
                                  onPressed: () => subscriptionController
                                      .showCancelSubscriptionDialog(
                                          context, trainee),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/add_sub.svg',
                                  height: 150.h,
                                  width: 150.w,
                                ),
                                SizedBox(height: 20.h),
                                CustomButton(
                                  fontSize: 22.sp,
                                  text: 'Add subscription',
                                  fill: true,
                                  color: Colors.redAccent.withOpacity(0.8),
                                  width: Get.width * 0.8,
                                  height: 50.h,
                                  onTap: () {
                                    subscriptionController
                                        .showSubscriptionButtom(trainee, 'Add');
                                  },
                                ),
                              ],
                            ),
                          ),
                    trainee.subscription != null
                        ? WorkoutsTabWidget(
                            isTrainer: true,
                            summary: workoutsController.workoutSummary.value,
                            workouts: workoutsController.workouts,
                            startDate: DatesUtils.getFormattedStartDate(
                              trainee.startWorOutDate,
                            ),
                            showAddWorkoutBottomSheet: (WorkoutModel? workout) {
                              workoutsController.showAddWorkoutBottomSheet(
                                  workout, trainee);
                            },
                            deleteWorkout: (WorkoutModel workout) {
                              workoutsController.deleteWorkout(
                                  trainee, workout);
                            },
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

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 140.w,
      height: 50.h,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white, size: 24.sp),
        label: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          elevation: 3,
        ),
      ),
    );
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
