import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/core/presentation/widgets/custom_container.dart';

class TraineesHeaderWidget extends StatelessWidget {
  final int totalTrainees;

  const TraineesHeaderWidget({required this.totalTrainees, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Trainees',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppStyle.softBrown,
            ),
          ),
          CustomContainer(
            text: totalTrainees.toString(),
            textColor: AppStyle.softOrange,
            fontSize: 18.sp,
          )
        ],
      ),
    );
  }
}
