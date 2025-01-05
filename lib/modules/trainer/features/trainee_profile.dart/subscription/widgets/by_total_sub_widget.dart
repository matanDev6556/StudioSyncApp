import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:studiosync/core/presentation/widgets/custom_container.dart';
import 'package:studiosync/core/presentation/widgets/linear_progress.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

class ByTotalSubscriptionContainer extends StatelessWidget {
  final DateTime? expiredDate;
  final int usedTrainings;
  final int totalTrainings;
  final Function? editButton;
  final bool isActive;

  const ByTotalSubscriptionContainer({
    Key? key,
    required this.expiredDate,
    required this.usedTrainings,
    required this.totalTrainings,
    required this.editButton,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyle.backGrey2,
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
          _buildDateInfo(),
          SizedBox(height: 15.h),
          _buildEditButton(),
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
                    '$usedTrainings / $totalTrainings',
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
                text: 'Monthly Usage',
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
            isActive: isActive,
            howWorkOutsDid: usedTrainings,
            totalWorkouts: totalTrainings,
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateColumn('Expired at', expiredDate),
      ],
    );
  }

  Widget _buildDateColumn(String label, DateTime? date) {
    // חישוב ההפרש בין התאריך הנוכחי לבין התאריך המופיע
    String daysLeft = '';
    if (date != null) {
      final DateTime now = DateTime.now();
      final Duration difference = date.difference(now);
      if (difference.inDays >= 0) {
        daysLeft = '${difference.inDays} days left';
      } else {
        daysLeft = 'Expired';
      }
    }

    return Container(
      width: Get.width * 0.90,
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
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // מאפשר מיקום של שני פריטים בצדדים
            children: [
              Row(
                children: [
                  Icon(Icons.event, color: AppStyle.softOrange, size: 20.sp),
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
              Text(
                'Left',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppStyle.softBrown,
                ),
              ),
            ],
          ),
          AppStyle.h(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date != null
                    ? DateFormat('dd/MM/yy').format(date)
                    : 'No expiration date',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                  color: AppStyle.deepBlackOrange,
                ),
              ),
              Text(
                expiredDate != null ? daysLeft : '',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                  color: AppStyle.deepBlackOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(Icons.edit, color: Colors.white),
        label: Text(
          'Edit Subscription',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        onPressed: editButton != null ? () => editButton!() : null,
        style: ElevatedButton.styleFrom(
          primary: AppStyle.softOrange,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}
