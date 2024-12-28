import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool fill;
  final Color color;
  final double width;
  final double? height;
  final VoidCallback? onTap;
  final bool isLoading; // New isLoading flag
  final double? fontSize;

  const CustomButton(
      {Key? key,
      required this.text,
      required this.fill,
      required this.color,
      required this.width,
      this.height,
      this.onTap,
      this.isLoading = false,
      this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap, // Disable tap if loading
      child: Center(
        child: Container(
          height: height ?? 55.h,
          width: width,
          decoration: BoxDecoration(
            color: fill ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color,
              width: 1,
            ),
          ),
          child: Center(
            child: isLoading
                ? CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppStyle.deepBlackOrange),
                  ) // Show loading indicator if loading
                : Text(
                    text,
                    style: TextStyle(
                      color: fill ? Colors.white : color,
                      fontSize: fontSize ?? 25.sp,
                      fontWeight: fill ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
