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
      height: Get.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShowLessonsSwitch(),
                  SizedBox(height: 24.h),
                  _buildFilterSection(
                      'Status',
                      lessonnsContoller.statusFilterOptions,
                      lessonnsContoller.statusFilter),
                  _buildFilterSection(
                      'Trainer',
                      ['All'] +
                          lessonnsContoller
                              .trainerController.trainer.value!.coachesList,
                      lessonnsContoller.trainerFilter),
                  _buildFilterSection(
                      'Type',
                      ['All'] +
                          lessonnsContoller
                              .trainerController.trainer.value!.lessonsTypeList,
                      lessonnsContoller.typeFilter),
                  _buildFilterSection(
                      'Location',
                      ['All'] +
                          lessonnsContoller
                              .trainerController.trainer.value!.locationsList,
                      lessonnsContoller.locationFilter),
                  // SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          // _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppStyle.softOrange.withOpacity(0.1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Lesson Filters',
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
    );
  }

  Widget _buildShowLessonsSwitch() {
    return Obx(
      () => SwitchListTile(
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
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildFilterSection(
      String title, List<String> options, RxString selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppStyle.softBrown,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(() => Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: options
                  .map((option) => _buildFilterChip(option, selectedValue))
                  .toList(),
            )),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildFilterChip(String option, RxString selectedValue) {
    return FilterChip(
      label: Text(option),
      selected: selectedValue.value == option,
      onSelected: (selected) {
        if (selected) {
          selectedValue.value = option;
        }
      },
      selectedColor: AppStyle.softOrange.withOpacity(0.3),
      checkmarkColor: AppStyle.softOrange,
      labelStyle: TextStyle(
        color: selectedValue.value == option
            ? AppStyle.deepBlackOrange.withOpacity(0.6)
            : AppStyle.softBrown,
        fontWeight:
            selectedValue.value == option ? FontWeight.bold : FontWeight.normal,
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
