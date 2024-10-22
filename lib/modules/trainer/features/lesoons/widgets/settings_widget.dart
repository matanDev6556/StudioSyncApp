// lesson_settings.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_lessons_controller.dart';

class LessonSettingsWidget extends StatelessWidget {
  final TrainerLessonsController lessonsController;

  const LessonSettingsWidget({
    Key? key,
    required this.lessonsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 15.h),
            decoration: BoxDecoration(
              color: AppStyle.softOrange.withOpacity(0.1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lesson Settings',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppStyle.deepBlackOrange,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppStyle.deepBlackOrange),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Obx(
              () => SwitchListTile(
                title: Text(
                  'Show Lessons',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppStyle.softBrown,
                  ),
                ),
                value: lessonsController.showLessons.value,
                onChanged: (value) =>
                    lessonsController.showLessons.value = value,
                activeColor: AppStyle.softOrange,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      child: ElevatedButton(
        onPressed: () {
          // Apply settings and close bottom sheet
          Get.back();
        },
        style: ElevatedButton.styleFrom(
          primary: AppStyle.softOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        child: Text(
          'Apply Filters',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
