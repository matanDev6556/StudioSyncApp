import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/modules/trainer/contollers/requests_controller.dart';
import 'package:studiosync/modules/trainer/features/lesoons/view/lessons_trainer_view.dart';
import 'package:studiosync/modules/trainer/features/notifications/widgets/tabs.buttom.dart';
import 'package:studiosync/modules/trainer/features/statistics/view/statistic_view.dart';
import 'package:studiosync/core/presentation/controllers/tabs_controller.dart';
import 'package:studiosync/core/presentation/widgets/app_bar.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainer/features/profile/presentation/trainer_controller.dart';
import 'package:studiosync/modules/trainer/features/profile/presentation/trainer_profile_view.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/trainees_list_view.dart';

class TrainerTabsView extends StatelessWidget {
  const TrainerTabsView({Key? key}) : super(key: key);

  // Define the list of pages
  static final List<Widget> _pages = <Widget>[
    const TrainerProfileTab(),
    const ClientsTab(),
    const SessionsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TrainerController>();
    final tabController = Get.find<GeneralTabController>();

    return Obx(() {
      final trainer = controller.trainer.value;
      final reqController = Get.find<RequestsController>();

      if (trainer == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return Scaffold(
        appBar: CustomAppBarTabs(
          userModel: trainer,
          onEditPressed: () => controller.setNewProfileImg(),
          onStatisticPressed: () {
            Get.bottomSheet(
              StatisticsView(),
              isScrollControlled: true,
            );
          },
          //TODO: add notificationCount to TabsButtom (use same as req controller)
          onNotificationPressed: () {
            Get.bottomSheet(
              Obx(() =>
                  TabsButtom(reqCount: reqController.traineesRequests.length)),
              isScrollControlled: true,
            );
          },
          thereIsNotifications: reqController.traineesRequests.isNotEmpty,
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
              icon: const Icon(Icons.group),
              label: 'Clients',
              activeIcon: Icon(Icons.group, color: AppStyle.deepBlackOrange),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.schedule),
              label: 'Sessions',
              activeIcon: Icon(Icons.schedule, color: AppStyle.deepBlackOrange),
            ),
          ],
        ),
      );
    });
  }
}

class TrainerProfileTab extends StatelessWidget {
  const TrainerProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TrainerEditProfile();
  }
}

class ClientsTab extends StatelessWidget {
  const ClientsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TraineesListView();
  }
}

class SessionsTab extends StatelessWidget {
  const SessionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LessonsView();
  }
}
