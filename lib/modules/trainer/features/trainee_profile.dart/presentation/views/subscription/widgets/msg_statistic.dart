import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

class WeightTrendMessageWidget extends StatelessWidget {
  final String message;

  const WeightTrendMessageWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppStyle.softOrange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.auto_graph,
              color: AppStyle.deepOrange,
              size: 25,
            ),
          ),
          AppStyle.w(10),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                color: AppStyle.softBrown.withOpacity(0.6),
                fontSize: 17.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
