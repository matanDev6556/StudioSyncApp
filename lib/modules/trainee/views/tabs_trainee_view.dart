import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/modules/auth/controllers/login_controller.dart';
import 'package:studiosync/modules/trainee/views/profile/trainee_profile_view.dart';

class TraineeTabsView extends StatelessWidget {
  const TraineeTabsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // מספר הלשוניות
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Trainee Home'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Profile'),
              Tab(text: 'Workouts'),
              Tab(text: 'Progress'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProfileTab(),
            WorkoutsTab(),
            ProgressTab(),
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  final loginController = Get.find<LoginController>();
  ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TraineeProfileTab();
  }
}

class WorkoutsTab extends StatelessWidget {
  const WorkoutsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Workout Plans Here'));
  }
}

class ProgressTab extends StatelessWidget {
  const ProgressTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Progress Tracking Here'));
  }
}
