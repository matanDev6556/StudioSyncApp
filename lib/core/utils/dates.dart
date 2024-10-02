import 'package:flutter/material.dart';


class DatesUtils {
 

 


  

  // function for when user pick dateTime i check that the date he choose is in the samee day he choosed
  static int getDayIndex(String? day) {
    switch (day) {
      case 'Sun':
        return 7;
      case 'Mon':
        return 1;
      case 'Tue':
        return 2;
      case 'Wed':
        return 3;
      case 'Thu':
        return 4;
      case 'Fri':
        return 5;
      case 'Sat':
        return 6;
      default:
        return 0; // Default to all days if day is not recognized
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
