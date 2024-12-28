import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_statistic_controller.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/core/presentation/widgets/custom_container.dart';

class StatisticsView extends StatelessWidget {
  final TrainerStatsController controller = Get.find();

  StatisticsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _refreshStats();
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingContainer();
      }

      return SingleChildScrollView(
        child: _buildStatsContainer(),
      );
    });
  }

  Widget _buildLoadingContainer() {
    return Container(
      height: Get.height * 0.8,
      padding: EdgeInsets.all(20.w),
      decoration: _buildContainerDecoration(),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildStatsContainer() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: _buildContainerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 20.h),
          _buildStatCards(),
        ],
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.r),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Monthly Statistics',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppStyle.softBrown,
          ),
        ),
        IconButton(
          onPressed: () async => await _refreshStats(),
          icon: Icon(
            Icons.refresh,
            color: AppStyle.backGrey3,
          ),
        )
      ],
    );
  }

  Widget _buildStatCards() {
    return Column(
      children: [
        _buildStatCard(
          title: 'Lessons',
          icon: Icons.fitness_center,
          currentValue: controller.currentMonthStats.value.sessionsCount,
          previousValue: controller.previousMonthStats.value.sessionsCount,
        ),
        SizedBox(height: 20.h),
        _buildStatCard(
          title: 'Trainee Registrations',
          icon: Icons.event,
          currentValue: controller.currentMonthStats.value.traineesCount,
          previousValue: controller.previousMonthStats.value.traineesCount,
        ),
        SizedBox(height: 20.h),
        _buildStatCard(
          title: 'New Trainees',
          icon: Icons.person_add,
          currentValue: controller.currentMonthStats.value.newTraineesCount,
          previousValue: controller.previousMonthStats.value.newTraineesCount,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required IconData icon,
    required int currentValue,
    required int previousValue,
  }) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: AppStyle.softOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatHeader(title, icon),
          SizedBox(height: 15.h),
          _buildStatValues(currentValue, previousValue),
          SizedBox(height: 10.h),
          _buildComparisonText(currentValue, previousValue),
        ],
      ),
    );
  }

  Widget _buildStatHeader(String title, IconData icon) {
    return Row(
      children: [
        CustomContainer(
          child: Icon(
            icon,
            color: AppStyle.softOrange,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: AppStyle.deepBlackOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatValues(int currentValue, int previousValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem('This Month', currentValue),
        _buildStatItem('Previous Month', previousValue),
      ],
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppStyle.softBrown,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppStyle.deepBlackOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonText(int current, int previous) {
    final difference = current - previous;
    final percentChange = _calculatePercentChange(current, previous);
    final isPositive = difference > 0;

    return Row(
      children: [
        Icon(
          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
          color: isPositive ? Colors.green : Colors.red,
          size: 16.sp,
        ),
        SizedBox(width: 5.w),
        Text(
          '${isPositive ? '+' : ''}$percentChange%',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: isPositive ? Colors.green : Colors.red,
          ),
        ),
        SizedBox(width: 5.w),
        Text(
          'from last month',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppStyle.softBrown,
          ),
        ),
      ],
    );
  }

  String _calculatePercentChange(int current, int previous) {
    if (previous == 0 && current > 0) {
      return (current * 100).toStringAsFixed(1);
    } else if (previous == 0 && current == 0) {
      return '0.0';
    }
    return ((current - previous) / previous * 100).toStringAsFixed(1);
  }

  Future<void> _refreshStats() async {
    controller.isLoading.value = true;
    await controller.calculateStats();
    controller.isLoading.value = false;
  }
}
