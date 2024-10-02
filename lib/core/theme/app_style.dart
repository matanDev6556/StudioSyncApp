import 'package:flutter/material.dart';

class AppStyle {
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
}