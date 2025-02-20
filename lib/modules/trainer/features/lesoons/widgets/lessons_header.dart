import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainer/features/lesoons/contollers/trainer_lessons_controller.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/add_edit_lesson_buttom.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/filters_buttom.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/settings_widget.dart';

class LessonsHeader extends StatelessWidget {
  final TrainerLessonsController controller;

  const LessonsHeader({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          _buildHeaderActions(),
        ],
      ),
    );
  }

  Widget _buildHeaderActions() {
    return Row(
      children: [
        HeaderIconButton(
          icon: Icons.add,
          onPressed: () => AppStyle.showCustomBottomSheet(
            content: LessonEditBottomSheet(
              title: 'Add lesson',
              onSave: (updatedLesson) => controller.addLesson(updatedLesson),
            ),
          ),
        ),
        HeaderIconButton(
          icon: Icons.tune,
          onPressed: () => AppStyle.showCustomBottomSheet(
            backgroundColor: Colors.transparent,
            content: LessonFiltersWidget(),
          ),
        ),
        HeaderIconButton(
          icon: Icons.schedule,
          onPressed: () => AppStyle.showCustomBottomSheet(
            backgroundColor: Colors.transparent,
            content: const LessonSettingsWidget(),
          ),
        ),
      ],
    );
  }
}

class HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const HeaderIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: AppStyle.softOrange),
      onPressed: onPressed,
    );
  }
}
