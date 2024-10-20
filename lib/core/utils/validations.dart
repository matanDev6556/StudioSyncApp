import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Validations {
  static String? validateEmptey(String? value, String type) {
    if (value == null || value.isEmpty) {
      return '$type is required';
    }
    return null;
  }

  static String? validOnlyNumbers(String? value, String type) {
    validateEmptey(value!, type);
    try {
      final v = double.tryParse(value);
      if (v! <= 0) {
        return 'Price not valid!';
      }
    } catch (e) {
      return "Only numbers!";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    validateEmptey(value, 'Email');

    final RegExp emailRegExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
      caseSensitive: false,
    );
    if (!emailRegExp.hasMatch(value!)) {
      return 'Invalid email format';
    }
    return null;
  }

  static void showValidationSnackBar(
    String msg,
    Color clr,
  ) {
    Get.snackbar(
      '',
      msg,
      backgroundColor: clr,
      colorText: Colors.white,
    );
  }
}
