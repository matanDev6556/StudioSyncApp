import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/router/routes.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/controllers/lessons_upcoming_controller.dart';
import 'package:studiosync/modules/trainer/features/lesoons/widgets/lesson_widget.dart';
import 'package:studiosync/core/presentation/widgets/custom_container.dart';

class UpcomingLessonsView extends GetView<UpcomingLessonsController> {
  const UpcomingLessonsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchRegisteredLessons();
    });

    return Column(
      children: [
        _buildHeader(),
        SizedBox(height: 15.h),
        Expanded(
          child: Obx(() => _buildLessonsList()),
        ),
        SizedBox(height: 15.h),
        _buildBookNowButton(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => Text(
                '${controller.registeredLessons.length} Upcoming Lessons',
                style: TextStyle(
                  color: AppStyle.softBrown,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              )),
          Icon(Icons.calendar_today, color: AppStyle.softOrange),
        ],
      ),
    );
  }

  Widget _buildLessonsList() {
    final lessons = controller.registeredLessons;

    if (lessons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomContainer(
              padding: EdgeInsets.all(16.sp),
              child: Icon(
                Icons.event_busy,
                size: 60.sp,
                color: AppStyle.softOrange,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'No upcoming\n lessons',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppStyle.softBrown,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return SizedBox(
          width: Get.width,
          child: LessonWidget(
            lessonModel: lesson,
            actionButton: _buildCancelButton(lesson),
          ),
        );
      },
    );
  }

  Widget _buildCancelButton(dynamic lesson) {
    return Center(
      child: ElevatedButton(
        onPressed: () => controller.cancleLesson(lesson),
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          onPrimary: Colors.white,
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text('Cancel'),
      ),
    );
  }

  Widget _buildBookNowButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: ElevatedButton(
        onPressed: () => Get.toNamed(Routes.trainerLessons),
        style: ElevatedButton.styleFrom(
          primary: AppStyle.deepBlackOrange,
          onPrimary: Colors.white,
          minimumSize: Size(double.infinity, 50.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Text(
          'Book Now',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
