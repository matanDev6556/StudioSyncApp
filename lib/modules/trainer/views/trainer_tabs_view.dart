import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/shared/widgets/app_bar.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_controller.dart';
import 'package:studiosync/modules/trainer/views/profile/trainer_profile_view.dart';
import 'package:studiosync/modules/trainer/views/trainees/trainees_list_view.dart';

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

    return Obx(() {
      final trainer = controller.trainer.value; // trainer is reactive
      return Scaffold(
        appBar: CustomAppBarTabs(
          userModel: trainer!, // use trainer inside Obx
          onEditPressed: () => controller.setNewProfileImg(),
          onNotificationPressed: () {},
          thereIsNotifications: false,
          isLoading: controller.isLoading.value,
        ),
        body: _pages[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.updateIndex,
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
    return TraineesListView();
  }
}

class SessionsTab extends StatelessWidget {
  const SessionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Upcoming Sessions Here'));
  }
}
