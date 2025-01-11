import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainer/features/lesoons/contollers/trainer_lessons_controller.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/add_edit_lesson_buttom.dart';
import 'package:studiosync/modules/lessons/presentation/widgets/days_selector.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/filters_widget.dart';
import 'package:studiosync/modules/lessons/presentation/widgets/lesson_widget.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/settings_widget.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_container.dart';

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
            Obx(
              () => WeekDaysSelector(
                selectedDayIndex: controller.selectedDayIndex.value,
                onDaySelected: (index) =>
                    controller.selectedDayIndex.value = index,
              ),
            ),
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
                    icon: Icon(Icons.tune, color: AppStyle.softOrange),
                    onPressed: () {
                      AppStyle.showCustomBottomSheet(
                        backgroundColor: Colors.transparent,
                        content: LessonFiltersWidget(),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.schedule,
                      color: AppStyle.softOrange,
                    ),
                    onPressed: () {
                      AppStyle.showCustomBottomSheet(
                        backgroundColor: Colors.transparent,
                        content: const LessonSettingsWidget(),
                      );
                    },
                  ),
                  //TODO : try another way
                  /* IconButton(
                    icon: Icon(
                      Icons.play_circle_outline,
                      color: AppStyle.softOrange,
                    ),
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('שחזור יומן השבוע שעבר ?'),
                          content:
                              const Text('האם ברצונך לשחזר את יומן שבוע שעבר?'),
                          actions: [
                            TextButton(
                              child: const Text('לא'),
                              onPressed: () => Get.back(),
                            ),
                            TextButton(
                              child: const Text('כן'),
                              onPressed: () {
                                //controller.duplicateLastWeekLessons();
                                //AppRouter.navigateBack();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  */
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
                  // lessons list
                  return ListView.builder(
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];
                      return LessonWidget(
                        lessonModel: lesson,
                        actionButton: Row(
                          children: [
                            _buildIconButton(
                              onTap: () {
                                AppStyle.showCustomBottomSheet(
                                  content: LessonEditBottomSheet(
                                    title: 'Add lesson',
                                    lesson: lesson,
                                    onSave: (updatedLesson) =>
                                        controller.addLesson(updatedLesson),
                                  ),
                                );
                              },
                              icon: Icons.copy,
                              color: AppStyle.softOrange,
                            ),
                            SizedBox(width: 8.w),
                            _buildIconButton(
                              onTap: () {
                                AppStyle.showCustomBottomSheet(
                                  content: LessonEditBottomSheet(
                                    title: 'Edit lesson',
                                    lesson: lesson,
                                    onSave: (updatedLesson) =>
                                        controller.editLesson(updatedLesson),
                                  ),
                                );
                              },
                              icon: Icons.edit,
                              color: AppStyle.deepBlackOrange,
                            ),
                            SizedBox(width: 8.w),
                            _buildIconButton(
                              onTap: () => controller.deleteLesson(lesson.id),
                              icon: Icons.delete,
                              color: Colors.redAccent,
                            ),
                            const Spacer(),
                            Obx(() => controller.isLoading.value
                                ? const CircularProgressIndicator()
                                : _buildActionButton(
                                    onTap: () =>
                                        controller.onDetailsTap(lesson),
                                    label: 'Details',
                                    color: AppStyle.softBrown,
                                  ))
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        // add lessons bttn
        Positioned(
          bottom: 16.h,
          right: 16.w,
          child: FloatingActionButton(
            onPressed: () {
              AppStyle.showCustomBottomSheet(
                content: LessonEditBottomSheet(
                  title: 'Add lesson',
                  onSave: (updatedLesson) =>
                      controller.addLesson(updatedLesson),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(8.w),
        child: Icon(icon, color: color, size: 20.sp),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required String label,
    required Color color,
  }) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        primary: color,
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: BorderSide(color: color),
        ),
      ),
      child: Text(label),
    );
  }
}
