// lesson_settings.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_lessons_settings.controller%20.dart';
import 'package:studiosync/shared/widgets/custom_container.dart';
import 'package:studiosync/shared/widgets/custom_text_field.dart';

class LessonSettingsWidget extends GetView<TrainerLessonsSettingsController> {
  const LessonSettingsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Row(
                  children: [
                    CustomContainer(
                      child:
                          Icon(Icons.settings, color: AppStyle.deepBlackOrange),
                    ),
                    AppStyle.w(5.w),
                    Text(
                      'Lesson Settings',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppStyle.deepBlackOrange,
                      ),
                    ),
                  ],
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
                value: controller.lessonsSettings.value.isAllowedToSchedule,
                onChanged: (value) => controller.updateLocalLessons(
                  controller.settings.copyWith(isAllowedToSchedule: value),
                ),
                activeColor: AppStyle.softOrange,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Message to trainees',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppStyle.softBrown,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7),
            child: CustomTextField(
              hintText: 'Enter message if nececery ',
              initialValue: controller.settings.message,
              hintColor: AppStyle.deepBlackOrange,
              fill: true,
              maxLines: 4,
              color: AppStyle.softOrange.withOpacity(0.2),
              onChanged: (val) => controller.updateLocalLessons(
                controller.lessonsSettings.value.copyWith(message: val),
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
          controller.updateLessonsSettings(controller.lessonsSettings.value);
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
          'Apply Settings',
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
