import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/lessons/data/model/lesson_model.dart';
import 'package:studiosync/modules/trainer/features/lesoons/contollers/trainer_lessons_controller.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/add_edit_lesson_buttom.dart';
import 'package:studiosync/modules/lessons/presentation/widgets/days_selector.dart';
import 'package:studiosync/modules/lessons/presentation/widgets/lesson_item.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/lessons_header.dart';
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
            LessonsHeader(controller: controller),
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
                        actionButton: lessonsActions(lesson),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        // add lessons bttn
      ],
    );
  }

  Row lessonsActions(LessonModel lesson) {
    return Row(
      children: [
        _buildIconButton(
          icon: Icons.copy,
          color: AppStyle.softOrange,
          onTap: () {
            AppStyle.showCustomBottomSheet(
              content: LessonEditBottomSheet(
                title: 'Add lesson',
                lesson: lesson,
                onSave: (updatedLesson) => controller.addLesson(updatedLesson),
              ),
            );
          },
        ),
        SizedBox(width: 8.w),
        _buildIconButton(
          icon: Icons.edit,
          color: AppStyle.deepBlackOrange,
          onTap: () {
            AppStyle.showCustomBottomSheet(
              content: LessonEditBottomSheet(
                title: 'Edit lesson',
                lesson: lesson,
                onSave: (updatedLesson) => controller.editLesson(updatedLesson),
              ),
            );
          },
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
                onTap: () => controller.onDetailsTap(lesson),
                label: 'Details',
                color: AppStyle.softBrown,
              ))
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
        foregroundColor: color,
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
