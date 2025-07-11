import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/presentation/router/app_router.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/workouts/data/model/workout_model.dart';
import 'package:studiosync/modules/trainer/features/trainee-sections/workouts/presentation/workouts_controller.dart';

class AddEditWorkoutBottomSheet extends GetView<WorkoutsController> {
  final List<String> bodyParts = ['Chest', 'Arms', 'Legs', 'Buttocks', 'Abs'];
  final WorkoutModel? workout;
  final TraineeModel? trainee;

  AddEditWorkoutBottomSheet({
    Key? key,
    this.workout,
    this.trainee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // אם אנחנו במצב עריכה, נטען את הנתונים הקיימים לאימונים
    if (workout != null) {
      controller.workoutFormHandler.weightController.text =
          workout!.weight.toString();
      for (int i = 0; i < workout!.listScopes.length; i++) {
        controller.workoutFormHandler.scopeControllers[i].text =
            workout!.listScopes[i].size.toString();
      }
    }

    return Container(
      height: Get.height * 0.85,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: AppStyle.backGrey2,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Center(
            child: Text(
              workout != null
                  ? 'Edit Workout'
                  : 'Add Workout', // שינוי הכותרת בהתאם למצב
              style: TextStyle(
                fontSize: 23.sp,
                fontWeight: FontWeight.bold,
                color: AppStyle.deepBlackOrange,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppStyle.softOrange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  'assets/icons/weight_icon.png',
                  height: 24.h,
                  color: AppStyle.softOrange,
                ),
              ),
              AppStyle.w(10.w),
              Text(
                'Weight',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.deepBlackOrange,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildTextField(
            controller: controller.workoutFormHandler.weightController,
            labelText: 'Weight (kg)',
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppStyle.softOrange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  'assets/icons/measure-1-svgrepo-com.png',
                  height: 24.h,
                  color: AppStyle.softOrange,
                ),
              ),
              AppStyle.w(10.w),
              Text(
                'Scopes',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppStyle.deepBlackOrange,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.separated(
              itemCount: bodyParts.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        bodyParts[index],
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppStyle.softBrown,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      flex: 3,
                      child: _buildTextField(
                        controller: controller
                            .workoutFormHandler.scopeControllers[index],
                        labelText: 'Size',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              if (workout != null) {
                controller.updateWorkout(trainee!, workout!);
                AppRouter.navigateBack();
              } else {
                controller.addWorkout(trainee!);
                AppRouter.navigateBack();
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: AppStyle.softOrange,
              minimumSize: Size(double.infinity, 56.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 2,
            ),
            child: Text(
              workout != null
                  ? 'Save Changes'
                  : 'Add Workout', // שינוי הכפתור בהתאם למצב
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: AppStyle.backGrey3,
          fontSize: 16.sp,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppStyle.backGrey2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppStyle.softOrange, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppStyle.backGrey2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      style: TextStyle(
        fontSize: 16.sp,
        color: AppStyle.deepBlackOrange,
      ),
    );
  }
}
