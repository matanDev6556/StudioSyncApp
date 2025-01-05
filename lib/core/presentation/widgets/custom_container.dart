import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart'; // If you're using this for responsive sizing

class CustomContainer extends StatelessWidget {
  final String? text;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final double? width;
  final double? height;
  final Widget? child;

  const CustomContainer({
    Key? key,
    this.text,
    this.padding,
    this.fontSize,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: AppStyle.boxShadow,
        color: backgroundColor ?? AppStyle.softOrange.withOpacity(0.2),
      ),
      child: text != null
          ? Text(
              text ?? '',
              style: TextStyle(
                color: textColor ?? AppStyle.softBrown,
                fontSize: fontSize ?? 16.sp,
              ),
            )
          : child,
    );
  }
}
