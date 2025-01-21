import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/core/presentation/utils/dates.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/controllers/lessons_trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/service/lessons_filter_service.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/widgets/trainee_filter_lessosn_buttom.dart';
import 'package:studiosync/modules/lessons/data/model/lesson_model.dart';
import 'package:studiosync/modules/lessons/presentation/widgets/days_selector.dart';
import 'package:studiosync/modules/lessons/presentation/widgets/lesson_widget.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_container.dart';

class TrainerLessonsView extends GetView<LessonsTraineeController> {
  const TrainerLessonsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: controller.lessonsSettings.value?.isAllowedToSchedule() ??
                      false
                  ? Column(
                      children: [
                        _buildWeekDaysSelector(),
                        _buildLessonsHeader(),
                        _buildFilterChips()
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            _buildLessonsList(),
          ],
        ),
      );
    });
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200.h,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 16.w, bottom: 16.h),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trainer Lessons',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Elevate Your Fitness Journey',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
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
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildWeekDaysSelector() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Obx(() => WeekDaysSelector(
            selectedDayIndex: controller.selectedDayIndex.value,
            onDaySelected: (index) => controller.setDayIndex(index),
          )),
    );
  }

  Widget _buildLessonsHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Row(
        children: [
          Obx(() => Text(
                '${controller.filteredLessons.length} Lessons',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppStyle.softBrown,
                  fontWeight: FontWeight.bold,
                ),
              )),
          const Spacer(),
          IconButton(
            onPressed: () => Get.bottomSheet(LessonFilterBottomSheet()),
            icon: Icon(
              Icons.tune,
              color: AppStyle.mutedBrown,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            children: [
              ..._buildFilterChipsByType(FilterType.lesson),
              ..._buildFilterChipsByType(FilterType.trainer),
              ..._buildFilterChipsByType(FilterType.location),
            ],
          ),
        ));
  }

  List<Widget> _buildFilterChipsByType(FilterType type) {
    List<String> filters;
    switch (type) {
      case FilterType.lesson:
        filters = controller.lessonFilterService.lessonsFilter;
        break;
      case FilterType.trainer:
        filters = controller.lessonFilterService.trainersFilter;
        break;
      case FilterType.location:
        filters = controller.lessonFilterService.locationFilter;
        break;
    }

    return filters
        .map((filter) => Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: FilterChip(
                label:
                    Text(filter, style: TextStyle(color: AppStyle.softBrown)),
                selected: true,
                onSelected: (selected) {
                  controller.lessonFilterService
                      .toggleFilter(type, filter, add: false);
                  controller.applyFilters();
                },
                selectedColor: AppStyle.softOrange.withOpacity(0.2),
                checkmarkColor: AppStyle.softOrange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r)),
              ),
            ))
        .toList();
  }

  Widget _buildLessonsList() {
    return Obx(() {
      final settings = controller.lessonsSettings.value;
      final lessons = controller.filteredLessons;
      if (settings != null) {
        if (!(settings.isAllowedToSchedule())) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomContainer(
                    padding: EdgeInsets.all(16.sp),
                    child: Icon(Icons.event_busy,
                        size: 70.sp, color: AppStyle.softOrange),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    DatesUtils.getDayAndHoursText(
                      dayOfWeek: settings.scheduledDayOfWeek,
                      startHour: settings.scheduledStartHour,
                      endHour: settings.scheduledEndHour,
                    ),
                    style:
                        TextStyle(fontSize: 18.sp, color: AppStyle.softBrown),
                    textAlign: TextAlign.center,
                  ),
                  AppStyle.h(10.h),
                  settings.message.isNotEmpty
                      ? CustomContainer(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            settings.message,
                            style: TextStyle(
                                fontSize: 18.sp, color: AppStyle.softBrown),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          );
        }
      }

      if (lessons.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomContainer(
                  padding: EdgeInsets.all(16.sp),
                  child: Icon(
                    Icons.event_busy,
                    size: 70.sp,
                    color: AppStyle.softOrange,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'No lessons\n available',
                  style: TextStyle(fontSize: 18.sp, color: AppStyle.softBrown),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final lesson = lessons[index];
            return _buildLessonItem(lesson);
          },
          childCount: lessons.length,
        ),
      );
    });
  }

  Widget _buildLessonItem(LessonModel lesson) {
    return LessonWidget(
        lessonModel: lesson,
        actionButton: Center(
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () async {
                      await controller.handleLessonPress(lesson);
                    },
              style: ElevatedButton.styleFrom(
                primary: _buttonColor(lesson),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
              child: Text(
                _buttonText(lesson),
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ));
  }

  String _buttonText(LessonModel lesson) {
    if (controller.checkIfTraineeInLesson(lesson)) {
      return 'Cancel';
    } else if (lesson.isLessonFull()) {
      return 'Full';
    } else {
      return 'Join';
    }
  }

  Color _buttonColor(LessonModel lesson) {
    if (controller.checkIfTraineeInLesson(lesson)) {
      return Colors.redAccent;
    } else if (lesson.isLessonFull()) {
      return Colors.grey;
    } else {
      return AppStyle.softOrange;
    }
  }
}
