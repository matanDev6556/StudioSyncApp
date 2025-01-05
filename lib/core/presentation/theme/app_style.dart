import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppStyle {
  // Text styles

  static final TextStyle titleStyle = TextStyle(
    fontSize: 20.sp, // גודל טקסט לכותרת
    fontWeight: FontWeight.bold,
    color: const Color(0xFF3A2F2F), // צבע מותאם לכותרת
  );
  static final TextStyle bodyTextStyle = TextStyle(
    fontSize: 16.sp,
    color: Colors.grey[800],
  );

  static final TextStyle summaryLabelStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: Colors.grey[600],
  );

  static final TextStyle summaryValueStyle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: AppStyle.backGrey2, // צבע כהה מותאם לערכי הסיכום
  );

  static final TextStyle softValueStyle = TextStyle(
    fontSize: 15.sp,

    color: AppStyle.softBrown.withOpacity(0.5), // צבע כהה מותאם לערכי הסיכום
  );

  static final TextStyle sectionTitleStyle = TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.bold,
    color: AppStyle.softBrown,
  );

  // Box shadows
  static final List<BoxShadow> boxShadow = [
    BoxShadow(
      color: Colors.grey.withOpacity(0.1),
      spreadRadius: 1,
      blurRadius: 5,
      offset: const Offset(0, 2),
    ),
  ];

  static Color deepOrange = const Color(0xffEDA400);
  static Color softOrange = const Color.fromARGB(255, 238, 204, 133);
  static Color deepBlackOrange = const Color(0xffB77F00);
  static Color backGrey = const Color(0xffEDEDED);
  static Color backGrey2 = const Color(0xffEDEDED);
  static Color backGrey3 = const Color.fromARGB(255, 173, 173, 173);

  // New colors
  static Color lightOrange = const Color(0xffF4B400); // גוון אורנג' בהיר
  static Color darkOrange = const Color(0xffC77C00); // גוון אורנג' כהה
  static Color softBrown = const Color(0xff7C4D00); // חום רך
  static Color mutedBrown = const Color(0xff8D6E63); // חום מעודן

  // Neutral colors
  static Color lightGrey = const Color(0xffF5F5F5); // אפור בהיר
  static Color mediumGrey = const Color(0xffB0BEC5); // אפור בינוני
  static Color darkGrey = const Color(0xff607D8B); // אפור כהה

  static h(double h) {
    return SizedBox(
      height: h,
    );
  }

  static w(double w) {
    return SizedBox(
      width: w,
    );
  }

  static double getScreenHeight() => Get.height;

  static double getScreenWidht() => Get.width;
}
