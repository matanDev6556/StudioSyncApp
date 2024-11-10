import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainee/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/lessons/views/upcoming_lessons_view.dart';
import 'package:studiosync/modules/trainee/features/profile/views/trainee_profile_view.dart';
import 'package:studiosync/modules/trainee/features/workouts/view/workouts_view.dart';
import 'package:studiosync/shared/controllers/tabs_controller.dart';
import 'package:studiosync/shared/widgets/app_bar.dart';
import 'package:studiosync/shared/widgets/custom_container.dart';

class TraineeTabsView extends StatelessWidget {
  const TraineeTabsView({Key? key}) : super(key: key);

  static final List<Widget> _pages = <Widget>[
    const TraineeProfileTab(),
    const TraineeWorkoutsTab(),
    const TraineeLessonsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TraineeController>();
    final tabController = Get.find<GeneralTabController>();

    return Obx(() {
      final trainee = controller.trainee.value; // trainer is reactive
      return Scaffold(
        appBar: CustomAppBarTabs(
          userModel: trainee!,
          onEditPressed: () => controller.setNewProfileImg(),
          onNotificationPressed: () {},
          thereIsNotifications: false,
          isLoading: controller.isLoading.value,
        ),
        body: _pages[tabController.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: tabController.selectedIndex.value,
          onTap: (index) => tabController.updateIndex(index),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.person,
              ),
              activeIcon: Icon(Icons.person, color: AppStyle.deepBlackOrange),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.fitness_center),
              label: 'Workouts',
              activeIcon:
                  Icon(Icons.fitness_center, color: AppStyle.deepBlackOrange),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.schedule),
              label: 'Lessons',
              activeIcon: Icon(Icons.schedule, color: AppStyle.deepBlackOrange),
            ),
          ],
        ),
      );
    });
  }
}

class TraineeProfileTab extends StatelessWidget {
  const TraineeProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TraineeProfileeView();
  }
}

class TraineeWorkoutsTab extends StatelessWidget {
  const TraineeWorkoutsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controler = Get.find<TraineeController>();
    return controler.trainee.value?.trainerID.isNotEmpty ?? false
        ? const WorkoutsView()
        : Center(
            child: CustomContainer(
              padding: EdgeInsets.all(16.h),
              text: 'You didnt connected to trainer yet!',
            ),
          );
  }
}

class TraineeLessonsTab extends StatelessWidget {
  const TraineeLessonsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controler = Get.find<TraineeController>();
    return controler.trainee.value?.trainerID.isNotEmpty ?? false
        ? UpcomingLessonsView()
        : Center(
            child: CustomContainer(
              padding: EdgeInsets.all(16.h),
              text: 'You didnt connected to trainer yet!',
            ),
          );
  }
}
