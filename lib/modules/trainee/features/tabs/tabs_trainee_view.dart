import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/lessons/presentation/views/upcoming_lessons_view.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/views/trainee_profile_view.dart';
import 'package:studiosync/core/presentation/widgets/general/app_bar.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_container.dart';
import 'package:studiosync/modules/trainee/features/trainee-sections/trainee_sections_view.dart';

class TraineeTabsView extends StatelessWidget {
  TraineeTabsView({Key? key}) : super(key: key);
  final _selectedIndex = 0.obs;

  

  @override
  Widget build(BuildContext context) {
    final traineeController = Get.find<TraineeController>();

    return Obx(() {
      final trainee = traineeController.trainee.value;

      if (trainee == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        appBar: CustomAppBarTabs(
          userModel: trainee,
          onEditPressed: () => traineeController.updateProfileImage(),
          onNotificationPressed: () {},
          thereIsNotifications: false,
          isLoading: traineeController.isLoading.value,
        ),
        body: _buildCurrentTab(_selectedIndex.value),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex.value,
          onTap: (index) => _selectedIndex.value = index,
          selectedItemColor: AppStyle.deepBlackOrange,
          unselectedItemColor: Colors.grey,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              activeIcon: Icon(Icons.person, color: AppStyle.deepBlackOrange),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.fitness_center),
              activeIcon:
                  Icon(Icons.fitness_center, color: AppStyle.deepBlackOrange),
              label: 'Workouts',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.schedule),
              activeIcon: Icon(Icons.schedule, color: AppStyle.deepBlackOrange),
              label: 'Lessons',
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCurrentTab(int index) {
    switch (index) {
      case 0:
        return const TraineeProfileTab();
      case 1:
        return const TraineeWorkoutsTab();
      case 2:
        return const TraineeLessonsTab();
      default:
        return Container();
    }
  }
}

class TraineeProfileTab extends StatelessWidget {
  const TraineeProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TraineeProfileView();
  }
}

class TraineeWorkoutsTab extends StatelessWidget {
  const TraineeWorkoutsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TraineeController>();
    return Obx(() {
      final trainee = controller.trainee.value;
      return trainee?.trainerID.isNotEmpty ?? false
          ? const TraineeSectionsView()
          : Center(
              child: CustomContainer(
                backgroundColor: Colors.red.withOpacity(0.2),
                textColor: Colors.red,
                padding: EdgeInsets.all(16.h),
                text: 'You haven\'t connected to a trainer yet!',
              ),
            );
    });
  }
}

class TraineeLessonsTab extends StatelessWidget {
  const TraineeLessonsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TraineeController>();
    return Obx(() {
      final trainee = controller.trainee.value;
      if (trainee == null) {
        return const Center(child: CircularProgressIndicator());
      }

      if (trainee.trainerID.isEmpty) {
        return Center(
          child: CustomContainer(
            backgroundColor: Colors.red.withOpacity(0.2),
            textColor: Colors.red,
            padding: EdgeInsets.all(16.h),
            text: 'You haven\'t connected to a trainer yet!',
          ),
        );
      }

      if (trainee.subscription == null) {
        return Center(
          child: CustomContainer(
            backgroundColor: Colors.red.withOpacity(0.2),
            textColor: Colors.red,
            padding: EdgeInsets.all(16.h),
            text: 'Your subscription is inactive\nTalk with your trainer!',
          ),
        );
      }

      return const UpcomingLessonsView();
    });
  }
}
