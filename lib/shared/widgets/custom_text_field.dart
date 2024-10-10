import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/theme/app_style.dart';

class CustomTextField extends StatelessWidget {
  final Icon? icon;
  final String hintText;
  final Color hintColor;
  final bool fill;
  final Color color;
  final double? width;
  final int? maxLines;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final double? height;
  final String? initialValue;
  final TextInputType keyboardType;
  final bool isHinttextCenter;
  final TextStyle? textStyle;

  const CustomTextField({
    super.key,
    this.icon,
    required this.hintText,
    required this.hintColor,
    required this.fill,
    required this.color,
    this.maxLines = 1,
    required this.onChanged,
    this.validator,
    this.height,
    this.width,
    this.initialValue,
    this.textStyle,
    this.isHinttextCenter = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    //final containerHeight = height ?? MediaQuery.of(context).size.height * 0.06;

    //final containerWidth = width ?? MediaQuery.of(context).size.width * 0.85;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        textAlign: isHinttextCenter ? TextAlign.center : TextAlign.start,
        initialValue: initialValue ?? '',
        style: textStyle ?? TextStyle(fontSize: 16.sp),
        validator: validator,
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: fill,
          fillColor: color,
          hintText: hintText,
          hintStyle: TextStyle(
            color: fill ? hintColor : color,
            fontSize: 14.sp,
          ),
          prefixIcon: icon != null
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: icon,
                )
              : null,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(color: AppStyle.softOrange, width: 2.w),
          ),
        ),
      ),
    );
  }
}
