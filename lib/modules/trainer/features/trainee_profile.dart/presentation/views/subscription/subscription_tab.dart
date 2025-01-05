// subscription_tab_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/core/presentation/widgets/custome_bttn.dart';

class SubscriptionTabWidget extends StatelessWidget {
  final TraineeModel trainee;
  final Function(BuildContext, TraineeModel) showBottomAddSubscription;

  const SubscriptionTabWidget({
    Key? key,
    required this.trainee,
    required this.showBottomAddSubscription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubscriptionSection(context),
        ],
      ),
    );
  }

  Widget _buildSubscriptionSection(BuildContext context) {
    return trainee.subscription != null
        ? trainee.subscription!.getSubscriptionContainer(
            isTrainer: true,
            editButton: () {
              showBottomAddSubscription(context, trainee);
            },
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/add_sub.svg',
                  height: 150.h,
                  width: 150.w,
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  fontSize: 22.sp,
                  text: 'Add subscription',
                  fill: true,
                  color: Colors.redAccent.withOpacity(0.8),
                  width: Get.width * 0.8,
                  height: 50.h,
                  onTap: () {
                    showBottomAddSubscription(context, trainee);
                  },
                ),
              ],
            ),
          );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Text(
        text,
        style: TextStyle(
          color: AppStyle.deepBlackOrange,
          fontWeight: FontWeight.bold,
          fontSize: 17.sp,
        ),
      ),
    );
  }
}
