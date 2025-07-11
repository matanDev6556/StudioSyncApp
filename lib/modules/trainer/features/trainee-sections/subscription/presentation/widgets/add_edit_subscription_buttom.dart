import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/trainee-sections/subscription/presentation/subscription_controller.dart';
import 'package:studiosync/modules/trainer/features/trainee-sections/subscription/presentation/widgets/number_controll_widget.dart';
import 'package:studiosync/core/presentation/widgets/general/date_selector.dart';

class AddSubscriptionWidget extends StatelessWidget {
  final TraineeModel trainee;
  final String title;

  const AddSubscriptionWidget({
    Key? key,
    required this.trainee,
    this.title = "Edit",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SubscriptionController controller =
        Get.find<SubscriptionController>();

    controller.initSub(trainee.subscription);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.r),
            topRight: Radius.circular(15.r),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  '$title Subscription',
                  style: TextStyle(
                    color: AppStyle.deepBlackOrange,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AppStyle.h(20),
              _text('Type'),
              AppStyle.h(5),
              // Subscription type selection
              _subscriptionTypeSelection(controller),
              AppStyle.h(10),
              Divider(thickness: 2, color: AppStyle.backGrey2),
              AppStyle.h(10),
              Obx(() => controller.selectedType.value ==
                      SubscriptionType.byTotalTrainings
                  ? _totalTrainingsSection(controller)
                  : _dateSubscriptionSection(controller)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _subscriptionTypeSelection(SubscriptionController controller) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: AppStyle.softOrange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            ListTile(
              title: Row(
                children: [
                  _icon(AppStyle.softOrange, Icons.date_range),
                  AppStyle.w(13),
                  Text(
                    'Subscription by Date',
                    style: TextStyle(color: AppStyle.softBrown),
                  ),
                ],
              ),
              trailing: Radio<SubscriptionType>(
                value: SubscriptionType.byDate,
                groupValue: controller.selectedType.value,
                onChanged: (value) => controller.updateSelectedType(value!),
              ),
            ),
            Divider(thickness: 1, color: AppStyle.softBrown.withOpacity(0.1)),
            ListTile(
              title: Row(
                children: [
                  _icon(AppStyle.softOrange, Icons.confirmation_number),
                  AppStyle.w(13),
                  Flexible(
                    child: Text(
                      'Subscription by Total Trainings',
                      style: TextStyle(color: AppStyle.softBrown),
                    ),
                  ),
                ],
              ),
              trailing: Radio<SubscriptionType>(
                value: SubscriptionType.byTotalTrainings,
                groupValue: controller.selectedType.value,
                onChanged: (value) => controller.updateSelectedType(value!),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _totalTrainingsSection(SubscriptionController controller) {
    return Obx(() {
      final subscription = controller.subscriptionByTotal.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _text('Expired date?'),
              const Spacer(),
              SizedBox(
                height: 30,
                width: 50.w,
                child: AnimatedToggleSwitch<bool>.dual(
                  current: subscription.expiredDate != null,
                  first: false,
                  second: true,
                  borderWidth: 3.0,
                  style: ToggleStyle(
                    borderColor: subscription.expiredDate != null
                        ? Colors.greenAccent
                        : Colors.redAccent,
                  ),
                  styleBuilder: (b) => ToggleStyle(
                    indicatorColor: b ? Colors.greenAccent : Colors.redAccent,
                  ),
                  onChanged: (b) => controller.updateExpredDate(b),
                ),
              ),
            ],
          ),
          AppStyle.h(15),
          subscription.expiredDate != null
              ? DateSelectionContainer(
                  initialDate: subscription.expiredDate,
                  onDateSelected: (date) =>
                      controller.updateSubscriptionByTotal(
                    subscription.copyWith(expiredTime: date),
                  ),
                )
              : const SizedBox(),
          AppStyle.h(15),
          _text('Total trainings'),
          AppStyle.h(5),
          WorkoutNumberControlRow(
            txtColor: AppStyle.softBrown.withOpacity(0.5),
            backColor: AppStyle.softOrange.withOpacity(0.4),
            value: subscription.totalTrainings,
            onAddTap: () =>
                controller.updateSubscriptionByTotal(subscription.copyWith(
              totalTrainings: subscription.totalTrainings + 1,
            )),
            onRemoveTap: () =>
                controller.updateSubscriptionByTotal(subscription.copyWith(
              totalTrainings: subscription.totalTrainings - 1,
            )),
          ),
          AppStyle.h(10.h),
          _text('Used trainings'),
          WorkoutNumberControlRow(
            txtColor: AppStyle.softBrown.withOpacity(0.5),
            backColor: AppStyle.softOrange.withOpacity(0.4),
            value: subscription.usedTrainings,
            onAddTap: () =>
                controller.updateSubscriptionByTotal(subscription.copyWith(
              usedTrainings: subscription.usedTrainings + 1,
            )),
            onRemoveTap: () =>
                controller.updateSubscriptionByTotal(subscription.copyWith(
              usedTrainings: subscription.usedTrainings - 1,
            )),
          ),
          AppStyle.h(20),
          _saveButton(controller),
        ],
      );
    });
  }

  Widget _dateSubscriptionSection(SubscriptionController controller) {
    return Obx(() {
      final subscription = controller.subscriptionByDate.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _text('Start Date'),
          AppStyle.h(5),
          DateSelectionContainer(
            bacColor: AppStyle.softOrange.withOpacity(0.2),
            txxColor: AppStyle.softBrown.withOpacity(0.5),
            initialDate: subscription.startDate,
            onDateSelected: (selectedDate) {
              controller.updateSubscriptionByDate(
                  subscription.copyWith(startDate: selectedDate));
            },
          ),
          AppStyle.h(10),
          _text('End Date'),
          AppStyle.h(5),
          DateSelectionContainer(
            bacColor: AppStyle.softOrange.withOpacity(0.2),
            txxColor: AppStyle.softBrown.withOpacity(0.5),
            initialDate: subscription.endDate,
            onDateSelected: (selectedDate) {
              controller.updateSubscriptionByDate(
                  subscription.copyWith(endDate: selectedDate));
            },
          ),
          AppStyle.h(10),
          _text('Trainings per month'),
          AppStyle.h(5),
          WorkoutNumberControlRow(
            txtColor: AppStyle.softBrown.withOpacity(0.5),
            backColor: AppStyle.softOrange.withOpacity(0.3),
            value: subscription.monthlyTrainingLimit,
            onAddTap: () => controller.updateSubscriptionByDate(
              subscription.copyWith(
                monthlyTrainingLimit: subscription.monthlyTrainingLimit + 1,
              ),
            ),
            onRemoveTap: () => controller.updateSubscriptionByDate(
              subscription.copyWith(
                monthlyTrainingLimit: subscription.monthlyTrainingLimit - 1,
              ),
            ),
          ),
          AppStyle.h(15),
          _saveButton(controller),
        ],
      );
    });
  }

  Padding _text(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        text,
        style: TextStyle(
          color: AppStyle.softBrown,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }

  Widget _icon(Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withOpacity(0.2),
      ),
      padding: const EdgeInsets.all(7),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  Widget _saveButton(SubscriptionController controller) {
    return ElevatedButton(
      onPressed: () => controller.save(trainee),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: AppStyle.softOrange,
        minimumSize: Size(double.infinity, 56.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 2,
      ),
      child: Text(
        'Save',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
