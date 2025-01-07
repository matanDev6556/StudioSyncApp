import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

class LinearProgressWorkOuts extends StatelessWidget {
  const LinearProgressWorkOuts({
    Key? key,
    required this.totalWorkouts,
    required this.howWorkOutsDid,
    required this.isActive,
    required this.leftTitle,
  }) : super(key: key);

  final int? totalWorkouts;
  final int? howWorkOutsDid;
  final bool isActive;
  final String leftTitle;

  @override
  Widget build(BuildContext context) {
    final progress =
        (totalWorkouts! > 0) ? howWorkOutsDid! / totalWorkouts! : 0.0;

    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, AppStyle.backGrey2.withOpacity(0.8)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: LinearProgressIndicator(
                  minHeight: 24.h,
                  value: progress,
                  backgroundColor: AppStyle.softOrange.withOpacity(0.3),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppStyle.softOrange),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppStyle.mutedBrown,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$howWorkOutsDid / $totalWorkouts $leftTitle',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppStyle.backGrey3,
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 6.r,
                    backgroundColor:
                        isActive ? Colors.greenAccent : Colors.redAccent,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppStyle.backGrey3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
