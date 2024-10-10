import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/theme/app_style.dart';

class WorkOutDataContainer extends StatelessWidget {
  final String? traineeDataWorkout;
  final String? iconPath;
  final String emptyDataReplace;

  const WorkOutDataContainer({
    Key? key,
    this.iconPath,
    this.traineeDataWorkout,
    this.emptyDataReplace = 'Not started yet',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, AppStyle.backGrey2.withOpacity(0.8)],
        ),
      ),
      child: Row(
        children: [
          if (iconPath != null)
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppStyle.softOrange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Image.asset(
                iconPath!,
                height: 24.h,
                width: 24.w,
                color: AppStyle.softOrange,
              ),
            ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              traineeDataWorkout ?? emptyDataReplace,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppStyle.backGrey3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
