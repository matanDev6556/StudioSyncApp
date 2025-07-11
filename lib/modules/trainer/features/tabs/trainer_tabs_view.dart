import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/modules/trainer/features/notifications/presentation/requests_controller.dart';
import 'package:studiosync/modules/trainer/features/lesoons/view/lessons_trainer_view.dart';
import 'package:studiosync/modules/trainer/features/notifications/presentation/widgets/tabs.buttom.dart';
import 'package:studiosync/core/presentation/widgets/general/app_bar.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainer/features/profile/presentation/trainer_controller.dart';
import 'package:studiosync/modules/trainer/features/profile/presentation/trainer_profile_view.dart';
import 'package:studiosync/modules/trainer/features/trainer-statistics/presentation/view/statistic_view.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/presentation/trainees_list_view.dart';

class TrainerTabsView extends StatelessWidget {
   TrainerTabsView({Key? key}) : super(key: key);
  final _selectedIndex = 0.obs;

  // Define the list of pages
  static final List<Widget> _pages = <Widget>[
    const TrainerProfileTab(),
    const ClientsTab(),
    const SessionsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TrainerController>();
    

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
            AppStyle.showCustomBottomSheet(
              content: Obx(() =>
                  TabsButtom(reqCount: reqController.traineesRequests.length)),
              isScrollControlled: true,
            );
          },
          thereIsNotifications: reqController.traineesRequests.isNotEmpty,
          isLoading: controller.isLoading.value,
        ),
        body: _pages[_selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex.value,
          onTap: (index) => _selectedIndex.value = index,
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
