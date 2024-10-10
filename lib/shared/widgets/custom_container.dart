import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/theme/app_style.dart'; // If you're using this for responsive sizing

class CustomContainer extends StatelessWidget {
  final String text; // Text to display
  final EdgeInsetsGeometry? padding; // Optional padding
  final Color? backgroundColor; // Optional background color
  final Color? textColor;

  const CustomContainer({
    Key? key,
    required this.text,
    this.padding,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppStyle.softOrange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? AppStyle.softBrown,
          fontSize: 16.sp,
        ),
      ),
    );
  }
}
