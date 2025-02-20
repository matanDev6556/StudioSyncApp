import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_container.dart';
import 'package:studiosync/core/presentation/widgets/general/linear_progress.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/core/data/models/sub_by_total_trainings_model.dart';

class ByTotalSubscriptionContainer extends StatelessWidget {
  final SubscriptionByTotalTrainings subscriptionByTotalTrainings;

  const ByTotalSubscriptionContainer({
    Key? key,
    required this.subscriptionByTotalTrainings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppStyle.softOrange.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthlyUsage(),
          SizedBox(height: 15.h),
          _buildProgressBar(),
          SizedBox(height: 15.h),
          _buildDateColumn(
              'Expired at', subscriptionByTotalTrainings.expiredDate),
        ],
      ),
    );
  }

  Widget _buildMonthlyUsage() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: AppStyle.softOrange.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workouts Used',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppStyle.softBrown,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${subscriptionByTotalTrainings.usedTrainings} / ${subscriptionByTotalTrainings.totalTrainings}',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: AppStyle.softOrange,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Used / Total',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppStyle.backGrey3,
                    ),
                  ),
                ],
              ),
              CustomContainer(
                textColor: AppStyle.softOrange,
                text: 'Total usage',
                backgroundColor: AppStyle.softOrange.withOpacity(0.1),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: AppStyle.softOrange.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress Bar',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppStyle.softBrown,
            ),
          ),
          SizedBox(height: 12.h),
          LinearProgressWorkOuts(
            leftTitle: 'Workouts',
            isActive: subscriptionByTotalTrainings.isActive(),
            howWorkOutsDid: subscriptionByTotalTrainings.usedTrainings,
            totalWorkouts: subscriptionByTotalTrainings.totalTrainings,
          ),
        ],
      ),
    );
  }

  Widget _buildDateColumn(String label, DateTime? date) {
    String daysLeft = '';
    if (date != null) {
      final DateTime now = DateTime.now();
      final Duration difference = date.difference(now);
      daysLeft =
          difference.inDays >= 0 ? '${difference.inDays} days left' : 'Expired';
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: AppStyle.softOrange.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.event, color: AppStyle.softOrange, size: 20.sp),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppStyle.softBrown,
                        ),
                        overflow: TextOverflow.ellipsis, // מונע overflow
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Text(
                  'Left',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppStyle.softBrown,
                  ),
                  overflow: TextOverflow.ellipsis, // מונע overflow
                ),
              ),
            ],
          ),
          AppStyle.h(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  date != null
                      ? DateFormat('dd/MM/yy').format(date)
                      : 'No expiration date',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                    color: AppStyle.deepBlackOrange,
                  ),
                  overflow: TextOverflow.ellipsis, // מונע overflow
                ),
              ),
              Flexible(
                child: Text(
                  subscriptionByTotalTrainings.expiredDate != null
                      ? daysLeft
                      : '',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                    color: AppStyle.deepBlackOrange,
                  ),
                  overflow: TextOverflow.ellipsis, // מונע overflow
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
