import 'package:flutter/material.dart';

class DatesUtils {
  // function for when user pick dateTime i check that the date he choose is in the samee day he choosed
 static String getDayFromIndex(int index) {
    switch (index) {
      case 0:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return '';
    }
  }

  // this function return how mutch the trainee with date subscription has days left
  static String daysLeft(DateTime startDate, DateTime endDate) {
    DateTime currentDate = DateTime.now();
    int totalDays = endDate.difference(startDate).inDays;
    int daysLeft = currentDate.difference(startDate).inDays;

    return '$daysLeft / $totalDays days';
  }

  static String getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    if (month >= 1 && month <= 12) {
      return monthNames[month - 1];
    } else {
      return 'Invalid Month';
    }
  }

  static String getHourFormat(TimeOfDay startTime, TimeOfDay endTime) {
    return '${startTime.hour.toString().padLeft(2, "0")}:${startTime.minute.toString().padLeft(2, "0")} - ${endTime.hour.toString().padLeft(2, "0")}:${endTime.minute.toString().padLeft(2, "0")}';
  }
}
