import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';
import 'package:studiosync/shared/widgets/custom_container.dart';

class LessonWidget extends StatelessWidget {
  final LessonModel lessonModel;
  final VoidCallback? deleteOnTap;
  final VoidCallback? editOnTap;
  final VoidCallback? detailsOnTap;
  final VoidCallback? copyOnTap;
  final bool isTrainer;
  final bool isLoading;

  const LessonWidget({
    Key? key,
    required this.lessonModel,
    this.deleteOnTap,
    this.editOnTap,
    this.detailsOnTap,
    this.copyOnTap,
    this.isTrainer = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppStyle.backGrey2.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoRow(
                icon: Icons.calendar_today,
                text:
                    DateFormat('dd MMM yyyy').format(lessonModel.startDateTime),
                color: AppStyle.deepBlackOrange,
              ),
              CustomContainer(
                child: _buildInfoRow(
                  text:
                      '${DateFormat('HH:mm').format(lessonModel.startDateTime)} - ${DateFormat('HH:mm').format(lessonModel.endDateTime)}',
                  color: AppStyle.softOrange,
                ),
              ),
            ],
          ),
          Divider(color: AppStyle.deepOrange.withOpacity(0.3), height: 24.h),
          _buildInfoRow(
            icon: Icons.fitness_center,
            text: lessonModel.typeLesson,
            color: AppStyle.deepBlackOrange,
          ),
          SizedBox(height: 8.h),
          _buildInfoRow(
            icon: Icons.location_on,
            text: lessonModel.location,
            color: AppStyle.deepBlackOrange,
          ),
          SizedBox(height: 8.h),
          _buildInfoRow(
            icon: Icons.person,
            text: lessonModel.trainerName,
            color: AppStyle.deepBlackOrange,
          ),
          SizedBox(height: 8.h),
          _buildProgressBar(
            current: lessonModel.traineesRegistrations.length,
            total: lessonModel.limitPeople,
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isTrainer)
                Row(
                  children: [
                    _buildIconButton(
                      onTap: copyOnTap ?? () {},
                      icon: Icons.copy,
                      color: AppStyle.softOrange,
                    ),
                    SizedBox(width: 8.w),
                    _buildIconButton(
                      onTap: editOnTap ?? () {},
                      icon: Icons.edit,
                      color: AppStyle.deepBlackOrange,
                    ),
                    SizedBox(width: 8.w),
                    _buildIconButton(
                      onTap: deleteOnTap ?? () {},
                      icon: Icons.delete,
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              isLoading
                  ? const CircularProgressIndicator()
                  : _buildActionButton(
                      onTap: detailsOnTap ?? () {},
                      label: 'Details',
                    ),
              // הצגת כפתורי העריכה רק אם המשתמש הוא מאמן
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    IconData? icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        icon != null
            ? CustomContainer(
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: color, size: 20.sp),
              )
            : const SizedBox(),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 15.sp,
            color: AppStyle.softBrown,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar({required int current, required int total}) {
    final double progress = total > 0 ? current / total : 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          icon: Icons.people,
          text: '$current / $total',
          color: AppStyle.deepBlackOrange,
        ),
        SizedBox(height: 10.h),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppStyle.softOrange.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(AppStyle.softOrange),
          minHeight: 10.h,
          borderRadius: BorderRadius.circular(3.r),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required String label,
  }) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        primary: AppStyle.softBrown,
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: BorderSide(color: AppStyle.softBrown),
        ),
      ),
      child: Text(label),
    );
  }

  Widget _buildIconButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(8.w),
        child: Icon(icon, color: color, size: 20.sp),
      ),
    );
  }
}
