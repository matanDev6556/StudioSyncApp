import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_lessons_controller.dart';

class WeekDaysSelector extends StatelessWidget {
  final TrainerLessonsController controller = Get.find();

  // Days of the week
  final List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  WeekDaysSelector({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(days.length, (index) {
              bool isSelected = index == controller.selectedDayIndex.value;
              return GestureDetector(
                onTap: () {
                  controller.selectedDayIndex.value = index;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppStyle.softOrange.withOpacity(0.5)
                        : AppStyle.softOrange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: AppStyle.deepBlackOrange.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                    ],
                  ),
                  child: Text(
                    days[index].substring(0, 3),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? AppStyle.softBrown
                          : AppStyle.softBrown.withOpacity(0.4),
                    ),
                  ),
                ),
              );
            }),
          )),
    );
  }
}
