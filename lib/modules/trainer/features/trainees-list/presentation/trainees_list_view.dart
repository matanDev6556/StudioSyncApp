import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/presentation/trainees_controller.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/presentation/widgets/search_bar_widget.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/presentation/widgets/trainees_count_widget.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/presentation/widgets/trainees_list_widget.dart';

class TraineesListView extends GetView<TraineesController> {
  const TraineesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Column(
            children: [
              SearchBarWidget(
                onSearchChanged: (value) => controller.updateSearchQuery(value),
                onFilterChanged: (value) =>
                    controller.updateActiveStatusFilter(value),
                dropdownValue: controller.activeStatusFilter.value,
              ),
              TraineesHeaderWidget(
                totalTrainees: controller.filteredTraineesList.length,
              ),
              Expanded(
                child: LiquidPullToRefresh(
                  onRefresh: () => controller.fetchTrainees(),
                  color: AppStyle.softOrange,
                  backgroundColor: Colors.white,
                  showChildOpacityTransition: false,
                  child: Obx(() => TraineesListWidget(
                        traineesList: controller.filteredTraineesList,
                        isLoading: controller.isLoading.value,
                      )),
                ),
              ),
            ],
          )),
    );
  }
}
