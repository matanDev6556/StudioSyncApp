import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/presentation/controllers/trainers_list_controller.dart';
import 'package:studiosync/core/presentation/utils/consts_lessons.dart';

class FilterTrainersBottomSheet extends StatelessWidget {
  final Function(bool, List<String>) onFilterSelected;

  const FilterTrainersBottomSheet({super.key, required this.onFilterSelected});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TrainersListController>();
    final RxBool tempInMyCity = false.obs;
    final RxList<String> tempSelectedLessons = <String>[].obs;

    // Initialize with current values
    tempInMyCity.value = controller.filters.value.inMyCity;
    tempSelectedLessons.assignAll(controller.filters.value.lessonsFilter);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Trainers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppStyle.softBrown,
              ),
            ),
            const SizedBox(height: 16),
            _buildCityToggle(tempInMyCity),
            const SizedBox(height: 16),
            _buildLessonTypesCheckboxes(tempSelectedLessons),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    tempSelectedLessons.clear();
                    tempInMyCity.value = false;
                  },
                  child: const Text('Clear All'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    onFilterSelected(tempInMyCity.value, tempSelectedLessons);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.softOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonTypesCheckboxes(RxList<String> selectedLessons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lesson Types',
          style: TextStyle(fontSize: 16, color: AppStyle.softBrown),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ConstsLessons.lessonsType.map((lessonType) {
            return Obx(
              () => FilterChip(
                label: Text(lessonType),
                selected: selectedLessons.contains(lessonType),
                onSelected: (selected) {
                  if (selected) {
                    selectedLessons.add(lessonType);
                  } else {
                    selectedLessons.remove(lessonType);
                  }
                },
                selectedColor: AppStyle.softOrange.withOpacity(0.2),
                checkmarkColor: AppStyle.softOrange,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCityToggle(RxBool inMyCity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Show trainers in my city only',
          style: TextStyle(fontSize: 16, color: AppStyle.softBrown),
        ),
        Obx(
          () => Switch(
            value: inMyCity.value,
            onChanged: (value) {
              inMyCity.value = value;
            },
            activeColor: AppStyle.softOrange,
          ),
        ),
      ],
    );
  }
}
