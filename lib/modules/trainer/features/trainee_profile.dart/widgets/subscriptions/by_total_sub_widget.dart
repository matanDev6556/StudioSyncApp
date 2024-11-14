import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:studiosync/shared/widgets/linear_progress.dart';
import 'package:studiosync/core/theme/app_style.dart';

class ByTotalSubscriptionContainer extends StatelessWidget {
  final DateTime? expiredDate;
  final int usedTrainings;
  final int totalTrainings;
  final Function? editButton;
  final bool isActive;
  final bool isTrainer;

  const ByTotalSubscriptionContainer({
    Key? key,
    required this.expiredDate,
    required this.usedTrainings,
    required this.totalTrainings,
    required this.editButton,
    this.isActive = false,
    this.isTrainer = true,
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
          LinearProgressWorkOuts(
            leftTitle: 'Workouts',
            isActive: isActive,
            isTrainer: isTrainer,
            howWorkOutsDid: usedTrainings,
            totalWorkouts: totalTrainings,
            editButton: editButton != null ? () => editButton!() : () {},
          ),
          AppStyle.h(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expired at',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppStyle.backGrey3,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppStyle.softOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  expiredDate != null
                      ? DateFormat('dd/MM/yy').format(expiredDate!)
                      : 'No expiration date',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppStyle.softOrange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
