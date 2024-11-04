import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:studiosync/shared/widgets/custom_container.dart';
import 'package:studiosync/shared/widgets/linear_progress.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/core/utils/dates.dart';

class ByDateSubscriptionWidget extends StatelessWidget {
  final int usedMonthlyTraining;
  final int monthlyTrainingLimit;
  final int currentMonth;
  final DateTime startDate;
  final DateTime endDate;
  final Function? editButton;
  final bool isTrainer;
  final bool Function() isActive;

  const ByDateSubscriptionWidget({
    Key? key,
    required this.usedMonthlyTraining,
    required this.monthlyTrainingLimit,
    required this.currentMonth,
    required this.startDate,
    required this.endDate,
    required this.editButton,
    this.isTrainer = true,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly used workouts',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppStyle.backGrey3,
                ),
              ),
              CustomContainer(
                textColor: AppStyle.softOrange,
                text:
                    '$usedMonthlyTraining/$monthlyTrainingLimit at ${DatesUtils.getMonthName(currentMonth)} ',
              ),
            ],
          ),
          SizedBox(height: 16.h),
          LinearProgressWorkOuts(
            leftTitle: 'Days',
            isActive: isActive(),
            isTrainer: isTrainer,
            howWorkOutsDid: DateTime.now().difference(startDate).inDays,
            totalWorkouts: endDate.difference(startDate).inDays,
            editButton: () => editButton ,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateInfo('Start', startDate),
              _buildDateInfo('End', endDate),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(String label, DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppStyle.backGrey3,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          DateFormat('dd/MM/yyyy').format(date),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppStyle.deepBlackOrange,
          ),
        ),
      ],
    );
  }
}
