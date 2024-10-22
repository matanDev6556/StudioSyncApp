// lesson_filters.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_lessons_controller.dart';

class LessonFiltersWidget extends StatelessWidget {
  final TrainerLessonsController lessonsController;

  const LessonFiltersWidget({
    Key? key,
    required this.lessonsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.8,
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
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection(
                    'Status',
                    lessonsController.statusFilterOptions,
                    lessonsController.statusFilter,
                  ),
                  _buildFilterSection(
                    'Trainer',
                    ['All'] +
                        lessonsController
                            .trainerController.trainer.value!.coachesList,
                    lessonsController.trainerFilter,
                  ),
                  _buildFilterSection(
                    'Type',
                    ['All'] +
                        lessonsController
                            .trainerController.trainer.value!.lessonsTypeList,
                    lessonsController.typeFilter,
                  ),
                  _buildFilterSection(
                    'Location',
                    ['All'] +
                        lessonsController
                            .trainerController.trainer.value!.locationsList,
                    lessonsController.locationFilter,
                  ),
                ],
              ),
            ),
          ),
        ],
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
}
