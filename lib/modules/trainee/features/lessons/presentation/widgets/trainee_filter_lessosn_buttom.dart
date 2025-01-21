import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/controllers/lessons_trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/service/lessons_filter_service.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/my_trainer_controller.dart';

class LessonFilterBottomSheet extends StatelessWidget {
  LessonFilterBottomSheet({
    Key? key,
  }) : super(key: key);

  final LessonsTraineeController lessonController = Get.find();
  final MyTrainerController myTrainerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Lessons',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppStyle.softBrown,
            ),
          ),
          const SizedBox(height: 16),
          _buildLessonTypesCheckboxes(),
          const SizedBox(height: 16),
          _buildTrainerChips(),
          const SizedBox(height: 16),
          _buildLocationChips(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  lessonController.lessonFilterService.lessonsFilter.clear();
                  lessonController.lessonFilterService.trainersFilter.clear();
                  lessonController.lessonFilterService.locationFilter.clear();
                },
                child: const Text('Clear All'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  lessonController.applyFilters();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  primary: AppStyle.softOrange,
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
    );
  }

  Widget _buildLessonTypesCheckboxes() {
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
          children: myTrainerController.myTrainer.value!.lessonsTypeList.map((type) {
            return Obx(
              () => FilterChip(
                label: Text(type),
                selected:
                    lessonController.lessonFilterService.lessonsFilter.contains(type),
                onSelected: (selected) {
                  if (selected) {
                    lessonController.lessonFilterService
                        .toggleFilter(FilterType.lesson, type);
                  } else {
                    lessonController.lessonFilterService
                        .toggleFilter(FilterType.lesson, type, add: false);
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

  Widget _buildTrainerChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trainers',
          style: TextStyle(fontSize: 16, color: AppStyle.softBrown),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: myTrainerController.myTrainer.value!.coachesList.map((trainer) {
            return Obx(
              () => FilterChip(
                label: Text(trainer),
                selected: lessonController.lessonFilterService.trainersFilter
                    .contains(trainer),
                onSelected: (selected) {
                  if (selected) {
                    lessonController.lessonFilterService
                        .toggleFilter(FilterType.trainer, trainer);
                  } else {
                    lessonController.lessonFilterService
                        .toggleFilter(FilterType.trainer, trainer, add: false);
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

  Widget _buildLocationChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Locations',
          style: TextStyle(fontSize: 16, color: AppStyle.softBrown),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: myTrainerController.myTrainer.value!.locationsList.map((location) {
            return Obx(
              () => FilterChip(
                label: Text(location),
                selected: lessonController.lessonFilterService.locationFilter
                    .contains(location),
                onSelected: (selected) {
                  if (selected) {
                    lessonController.lessonFilterService
                        .toggleFilter(FilterType.location, location);
                  } else {
                    lessonController.lessonFilterService
                        .toggleFilter(FilterType.trainer, location, add: false);
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
}
