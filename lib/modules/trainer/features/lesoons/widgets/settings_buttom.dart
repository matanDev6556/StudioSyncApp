import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_lessons_controller.dart';

class LessonSettingsBottomSheet extends StatelessWidget {
  final lessonnsContoller = Get.find<TrainerLessonsController>();
  LessonSettingsBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Text(
            'Lesson Settings',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppStyle.deepBlackOrange,
            ),
          ),
          SizedBox(height: 24.h),
          _buildShowLessonsSwitch(),
          SizedBox(height: 24.h),
          Text(
            'Filter Lessons',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppStyle.deepBlackOrange,
            ),
          ),
          SizedBox(height: 12.h),
          _buildFilterDropdown(),
          SizedBox(height: 24.h),
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildShowLessonsSwitch() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: AppStyle.backGrey2.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: SwitchListTile(
            title: Text(
              'Show Lessons',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppStyle.softBrown,
              ),
            ),
            value: lessonnsContoller.showLessons.value,
            onChanged: (value) => lessonnsContoller.showLessons.value = value,
            activeColor: AppStyle.softOrange,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          ),
        ));
  }

  Widget _buildFilterDropdown() {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppStyle.backGrey2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: lessonnsContoller.filterOption.value,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: AppStyle.softBrown),
              style: TextStyle(
                fontSize: 16.sp,
                color: AppStyle.softBrown,
              ),
              items: [
                'All',
                'Active',
                'Past',
                'Upcoming',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('$value Lessons'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  lessonnsContoller.setFilter(value);
                }
              },
            ),
          ),
        ));
  }

  Widget _buildApplyButton() {
    return SizedBox(
      width: double.infinity,
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
