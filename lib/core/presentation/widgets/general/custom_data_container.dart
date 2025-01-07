import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

class CustomDataContainer extends StatelessWidget {
  final String? text;
  final Widget? leadingIcon;
  final String emptyDataMessage;
  final BoxDecoration? customDecoration;

  const CustomDataContainer({
    Key? key,
    this.text,
    this.leadingIcon,
    this.emptyDataMessage = 'No data available',
    this.customDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: customDecoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, AppStyle.backGrey2],
            ),
          ),
      child: Row(
        children: [
          if (leadingIcon != null)
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppStyle.softOrange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: leadingIcon,
            ),
          if (leadingIcon != null) SizedBox(width: 16.w),
          Expanded(
            child: Text(
              text ?? emptyDataMessage,
              style: TextStyle(
                fontSize: 17.sp,
                color: AppStyle.softBrown.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
