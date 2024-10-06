import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/modules/trainer/contollers/trainees_controller.dart';
import 'package:studiosync/modules/trainer/views/trainees/widgets/search_bar_widget.dart';
import 'package:studiosync/modules/trainer/views/trainees/widgets/trainees_count_widget.dart';
import 'package:studiosync/modules/trainer/views/trainees/widgets/trainees_list_widget.dart';

class TraineesListView extends GetView<TraineesController> {
  const TraineesListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            TraineesHeaderWidget(
              totalTrainees: controller.filteredTraineesList.length,
            ),
            SearchBarWidget(
              onSearchChanged: (value) => controller.updateSearchQuery(value),
              onFilterChanged: (value) =>
                  controller.updateActiveStatusFilter(value),
              dropdownValue: controller.activeStatusFilter.value,
            ),
            Expanded(
              child: TraineesListWidget(
                traineesList: controller.filteredTraineesList,
                isLoading: controller.isLoading.value,
              ),
            ),
          ],
        ));
  }
}
