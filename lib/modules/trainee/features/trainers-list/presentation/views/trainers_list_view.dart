import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/router/app_touter.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/presentation/controllers/trainers_list_controller.dart';
import 'package:studiosync/modules/trainee/features/profile/widgets/my_trainer_widget.dart';

class TrainersListView extends GetView<TrainersListController> {
  const TrainersListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildSearchAndFilters()),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            sliver: _buildTrainersList(),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200.h,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/image_login.png',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
            Positioned(
              bottom: 16.h,
              left: 16.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find Your Perfect Trainer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Discover expert trainers tailored to your needs',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => AppRouter.navigateBack(),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      color: AppStyle.softOrange.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          _buildListCount(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search trainers...',
            prefixIcon: Icon(Icons.search, color: AppStyle.softOrange),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 12.h),
          ),
          onChanged: (value) {
            controller.setSearchQuery(value);
          },
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (controller.filters.value.inMyCity)
                _buildChip("Nearby", controller.filters.value.inMyCity,
                    (selected) {
                  controller.setIsInMyCity(selected);
                }),
              ...controller.filters.value.lessonsFilter
                  .map((filter) => _buildChip(filter, true, (selected) {
                        if (!selected) {
                          controller.removeFilter(filter);
                        }
                      })),
            ],
          ),
        ));
  }

  Widget _buildChip(
      String label, bool selected, ValueChanged<bool>? onSelected) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        selectedColor: AppStyle.softOrange,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppStyle.softBrown,
          fontWeight: FontWeight.bold,
        ),
        shape: StadiumBorder(
          side: BorderSide(color: AppStyle.softOrange),
        ),
      ),
    );
  }

  Widget _buildListCount() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.h),
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
      if (controller.errorMessage.isNotEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Text(controller.errorMessage.value,
                style: const TextStyle(color: Colors.red)),
          ),
        );
      }

      if (controller.isLoading.value) {
        return SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppStyle.softOrange),
            ),
          ),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final trainer = controller.filteredTrainers[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: MyTrainerWidget(
                key: ValueKey(trainer.userId),
                trainerModel: trainer,
                onClick: () => AppRouter.navigateWithArgs(
                  Routes.trainerProfile,
                  trainer,
                ),
              ),
            );
          },
          childCount: controller.filteredTrainers.length,
        ),
      );
    });
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => controller.showFilterBottomSheet(),
      icon: const Icon(
        Icons.tune,
        color: Colors.white,
      ),
      label: const Text(
        'Filters',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: AppStyle.softOrange,
    );
  }
}
