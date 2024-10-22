import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_lessons_controller.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/days_selector.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/lesson_widget.dart';
import 'package:studiosync/shared/widgets/custom_container.dart';

class LessonsView extends StatelessWidget {
  final TrainerLessonsController controller =
      Get.find<TrainerLessonsController>();

  LessonsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            WeekDaysSelector(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Obx(
                    () => Text(
                      controller.filteredLessons.length < 2
                          ? 'Lessons (${controller.statusFilter})'
                          : '${controller.filteredLessons.length} Lessons (${controller.statusFilter})',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: AppStyle.softBrown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: AppStyle.backGrey3.withOpacity(0.6),
                    ),
                    onPressed: () => controller.showLessonSettingsBottomSheet(),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list, color: AppStyle.softOrange),
                    onPressed: () => controller.showLessonFilterBottomSheet(),
                  ),
                ],
              ),
            ),
            AppStyle.h(10.h),
            Expanded(
              child: Obx(
                () {
                  final lessons = controller.filteredLessons;

                  if (lessons.isEmpty) {
                    return const Center(
                      child: CustomContainer(
                        text: 'No lessons!',
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];
                      return LessonWidget(
                        lessonModel: lesson,
                        isTrainer: true,
                        deleteOnTap: () => controller.deleteLesson(lesson.id),
                        editOnTap: () {
                          controller.showLessonBottomSheet(
                            title: 'Edit lesson',
                            lesson: lesson,
                            onSave: (updatedLesson) =>
                                controller.editLesson(updatedLesson),
                          );
                        },
                        copyOnTap: () {
                          controller.showLessonBottomSheet(
                            title: 'Add lesson',
                            lesson: lesson,
                            onSave: (updatedLesson) =>
                                controller.addLesson(updatedLesson),
                          );
                        },
                        detailsOnTap: () => controller.onDetailsTap(lesson),
                        isLoading: controller.isLoading.value,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 16.h,
          right: 16.w,
          child: FloatingActionButton(
            onPressed: () {
              // הוסף את הקוד להוספת שיעור חדש כאן
              controller.showLessonBottomSheet(
                title: 'Add lesson',
                onSave: (newLesson) => controller.addLesson(newLesson),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
