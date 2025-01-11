import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_container.dart';
import 'package:studiosync/core/presentation/widgets/general/linear_progress.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/core/presentation/utils/dates.dart';
import 'package:studiosync/core/data/models/sub_by_date_model.dart';

class ByDateSubscriptionWidget extends StatelessWidget {
  final SubscriptionByDate subscriptionByDate;
  const ByDateSubscriptionWidget({Key? key, required this.subscriptionByDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppStyle.backGrey2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthlyUsage(),
          SizedBox(height: 15.h),
          _buildProgressBar(),
          SizedBox(height: 15.h),
          _buildDateInfo(),
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
            'Monthly Workouts',
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
                    '${subscriptionByDate.usedMonthlyTraining} / ${subscriptionByDate.monthlyTrainingLimit}',
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
                text: DatesUtils.getMonthName(subscriptionByDate.currentMonth),
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
            'Subscription Progress',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppStyle.softBrown,
            ),
          ),
          SizedBox(height: 12.h),
          LinearProgressWorkOuts(
            leftTitle: 'Days',
            isActive: subscriptionByDate.isActive(),
            howWorkOutsDid:
                DateTime.now().difference(subscriptionByDate.startDate).inDays,
            totalWorkouts: subscriptionByDate.endDate
                .difference(subscriptionByDate.startDate)
                .inDays,
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateColumn(
            'Start Date', subscriptionByDate.startDate, Icons.calendar_today),
        _buildDateColumn('End Date', subscriptionByDate.endDate, Icons.event),
      ],
    );
  }

  Widget _buildDateColumn(String label, DateTime date, IconData icon) {
    return Container(
      width: Get.width * 0.44,
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
            children: [
              Icon(icon, color: AppStyle.softOrange, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppStyle.softBrown,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            DateFormat('dd MMM yyyy').format(date),
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w400,
              color: AppStyle.deepBlackOrange,
            ),
          ),
        ],
      ),
    );
  }
}
