import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainee/controllers/trainers_list_controller.dart';
import 'package:studiosync/modules/trainee/features/profile/widgets/my_trainer_widget.dart';

class TrainersListView extends GetView<TrainersListController> {
  const TrainersListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.markedFilters.value) {
        controller.showFilterBottomSheet();
      } else {
        controller.fetchTrainers();
      }
    });
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          _buildListCount(),
          Expanded(
            child: _buildTrainersList(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Trainers',
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: AppStyle.softBrown,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 2,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: AppStyle.softOrange),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.filter_list, color: AppStyle.softOrange),
            onPressed: () => controller.showFilterBottomSheet()),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search trainers...',
          prefixIcon: Icon(Icons.search, color: AppStyle.softOrange),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(color: AppStyle.softOrange),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(color: AppStyle.softOrange, width: 2),
          ),
        ),
        onChanged: (value) {
          controller.searchQuery.value = value;
          controller.applyFilters();
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              _buildChip("Nearby", controller.inMyCity.value, (selected) {
                controller.inMyCity.value = selected;
                controller.fetchTrainers();
              }),
              ...controller.lessonsFilter
                  .map((filter) => _buildChip(filter, true, (selected) {
                        if (!selected) {
                          controller.removeFilter(filter);
                          controller.applyFilters();
                        }
                      })),
            ],
          ),
        ));
  }

  Widget _buildChip(
      String label, bool selected, ValueChanged<bool>? onSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        selectedColor: AppStyle.softOrange.withOpacity(0.2),
        checkmarkColor: AppStyle.softOrange,
      ),
    );
  }

  Widget _buildListCount() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Obx(() => Text(
            '${controller.filteredTrainers.length} trainers found',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: AppStyle.softBrown,
            ),
          )),
    );
  }

  Widget _buildTrainersList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      return ListView.builder(
        itemBuilder: ((context, index) {
          final trainer = controller.filteredTrainers[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: MyTrainerWidget(
              trainerModel: trainer,
              onClick: () =>
                  Get.toNamed(Routes.myTrainerProfile, arguments: trainer),
            ),
          );
        }),
        itemCount: controller.filteredTrainers.length,
      );
    });
  }
}
