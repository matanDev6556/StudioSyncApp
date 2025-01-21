import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/modules/workouts/data/model/workout_summary.dart';
import 'package:studiosync/core/presentation/router/routes.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_container.dart';
import 'package:studiosync/modules/workouts/data/model/workout_model.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_data_container.dart';
import 'package:studiosync/modules/workouts/presentation/widgets/workouts_horizontal_list.dart';

class WorkoutsTabWidget extends StatelessWidget {
  final WorkoutSummary summary;
  final List<WorkoutModel> workouts;
  final String startDate;
  final bool isTrainer;
  final Function(WorkoutModel?)? showAddWorkoutBottomSheet;
  final Function(WorkoutModel)? deleteWorkout;

  const WorkoutsTabWidget({
    Key? key,
    required this.summary,
    required this.workouts,
    required this.startDate,
    required this.isTrainer,
    this.showAddWorkoutBottomSheet,
    this.deleteWorkout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Start At'),
              SizedBox(height: 10.h),
              CustomDataContainer(
                text: startDate,
                leadingIcon: Image.asset('assets/icons/clock_icon.png'),
              ),
              SizedBox(height: 20.h),
              _buildWorkoutSection(),
            ],
          ),
        ),
        if (isTrainer) ...[
          Positioned(
            bottom: 16.h,
            right: 16.w,
            child: FloatingActionButton(
              onPressed: () => showAddWorkoutBottomSheet?.call(null),
              backgroundColor: AppStyle.softOrange,
              child: Icon(Icons.add, color: AppStyle.darkOrange),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWorkoutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _sectionTitle('Workouts'),
            const Spacer(),
            CustomContainer(
              backgroundColor: AppStyle.softOrange.withOpacity(0.4),
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 20.h,
                  color: AppStyle.deepBlackOrange,
                ),
                onPressed: () => Get.toNamed(
                  Routes.allTraineeWorkouts,
                  arguments: {
                    'workouts': workouts,
                    'onEdit': isTrainer
                        ? (WorkoutModel workout) {
                            showAddWorkoutBottomSheet?.call(workout);
                          }
                        : null,
                    'onDelete': isTrainer
                        ? (WorkoutModel workout) {
                            deleteWorkout?.call(workout);
                          }
                        : null,
                    'summary': summary,
                    'isTrainer': isTrainer,
                  },
                ),
              ),
            )
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
                onDelete: isTrainer ? deleteWorkout : null,
                onEdit: isTrainer ? showAddWorkoutBottomSheet : null,
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
