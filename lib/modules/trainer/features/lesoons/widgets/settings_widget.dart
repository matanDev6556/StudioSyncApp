import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainer/features/lesoons/contollers/trainer_lessons_settings.controller%20.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_container.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_text_field.dart';

class LessonSettingsWidget extends GetView<TrainerLessonsSettingsController> {
  const LessonSettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildShowLessonsSwitch(),
              _buildDaySelector(),
              _buildTimeSelector(context),
              _buildDivider(),
              AppStyle.h(10),
              _buildMessageTextField(),
              AppStyle.h(10),
              _buildDivider(),
              //TODO : add cancle howers before the lesson
              _buildApplyButton(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
                child: Icon(Icons.schedule, color: AppStyle.deepBlackOrange),
              ),
              SizedBox(width: 10.w),
              Text(
                'Lesson Schedule',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.deepBlackOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShowLessonsSwitch() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Enable Lesson Scheduling',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppStyle.softBrown,
            ),
          ),
          Switch(
            value: controller.isAlloweingToSheduleNow.value ?? false,
            onChanged: (va) {},
            activeColor: AppStyle.softOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lesson Day',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppStyle.softBrown,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppStyle.softOrange),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: controller.settings.scheduledDayOfWeek,
                  onChanged: (value) {
                    controller.updateLocalLessons(
                      controller.settings.copyWith(scheduledDayOfWeek: value),
                    );
                  },
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Sunday')),
                    DropdownMenuItem(value: 1, child: Text('Monday')),
                    DropdownMenuItem(value: 2, child: Text('Tuesday')),
                    DropdownMenuItem(value: 3, child: Text('Wednesday')),
                    DropdownMenuItem(value: 4, child: Text('Thursday')),
                    DropdownMenuItem(value: 5, child: Text('Friday')),
                    DropdownMenuItem(value: 6, child: Text('Saturday')),
                  ],
                  hint: const Text('Select a day'),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        thickness: 1,
        color: AppStyle.softBrown.withOpacity(0.2),
      ),
    );
  }

  Widget _buildTimeSelector(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: _buildTimePicker(
              context,
              'Start Time',
              controller.settings.scheduledStartHour,
              (pickedTime) => controller.updateLocalLessons(
                controller.settings
                    .copyWith(scheduledStartHour: pickedTime.hour),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildTimePicker(
              context,
              'End Time',
              controller.settings.scheduledEndHour,
              (pickedTime) => controller.updateLocalLessons(
                controller.settings.copyWith(scheduledEndHour: pickedTime.hour),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, String label, int? currentHour,
      Function(TimeOfDay) onTimeSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppStyle.softBrown,
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () async {
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(
                currentHour != null
                    ? DateTime(0, 0, 0, currentHour, 0)
                    : DateTime.now(),
              ),
            );
            if (pickedTime != null) {
              onTimeSelected(pickedTime);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(color: AppStyle.softOrange),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currentHour != null
                      ? '${currentHour.toString().padLeft(2, '0')}:00'
                      : 'Select Time',
                  style: TextStyle(fontSize: 16.sp, color: AppStyle.softBrown),
                ),
                Icon(Icons.access_time, color: AppStyle.softOrange),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: CustomTextField(
        initialValue: controller.settings.message,
        hintText: 'Message to trainees',
        hintColor: AppStyle.softBrown,
        maxLines: 4,
        fill: true,
        color: AppStyle.softOrange.withOpacity(0.3),
        onChanged: (val) {
          controller
              .updateLocalLessons(controller.settings.copyWith(message: val));
        },
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      child: ElevatedButton(
        onPressed: () {
          controller.updateLessonsSettings();
          
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
