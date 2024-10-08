import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/theme/app_style.dart';

class WeightTrendMessageWidget extends StatelessWidget {
  final String message;

  const WeightTrendMessageWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppStyle.softOrange.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_graph,
            color: AppStyle.deepOrange,
            size: 25,
          ),
          AppStyle.w(10),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                color: AppStyle.softBrown,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
