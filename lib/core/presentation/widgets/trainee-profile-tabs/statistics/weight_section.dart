import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_container.dart';

class StatisticsSection extends StatelessWidget {
  final List<dynamic> workouts;
  final String weightTrend;

  const StatisticsSection({
    Key? key,
    required this.workouts,
    required this.weightTrend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (workouts.length < 2) {
      return CustomContainer(
        padding: EdgeInsets.all(16.h),
        width: Get.width,
        backgroundColor: Colors.white,
        child: Text(
          'Not enough workouts to show statistics',
          style: AppStyle.bodyTextStyle,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomContainer(
          width: Get.width,
          backgroundColor: Colors.white,
          textColor: AppStyle.softBrown.withOpacity(0.6),
          fontSize: 17.sp,
          padding: EdgeInsets.all(16.h),
          child: Text(
            weightTrend,
            style: AppStyle.bodyTextStyle,
          ),
        ),
        AppStyle.h(10),
      ],
    );
  }
}
