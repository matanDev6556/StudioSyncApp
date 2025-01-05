// subscription_tab_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/core/presentation/widgets/custom_container.dart';
import 'package:studiosync/core/presentation/widgets/custom_dialog.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/core/presentation/widgets/custome_bttn.dart';

class SubscriptionTabWidget extends StatelessWidget {
  final TraineeModel trainee;
  final Function(TraineeModel) showBottomAddSubscription;
  final Function() cancleSub;

  const SubscriptionTabWidget({
    Key? key,
    required this.trainee,
    required this.showBottomAddSubscription,
    required this.cancleSub,
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
        ? Column(
            children: [
              trainee.subscription!.getSubscriptionContainer(
                isTrainer: true,
                editButton: () {
                  showBottomAddSubscription(trainee);
                },
              ),
              AppStyle.h(10.h),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog(
                          msg:
                              'Are you sure you want to cancel ${trainee.userFullName}\'s subscription?',
                          onConfirm: () => cancleSub());
                    },
                  );
                },
                child: CustomContainer(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  backgroundColor: Colors.redAccent.withOpacity(0.6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      Text(
                        'Cancle Subscription',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        : Center(
            child: SingleChildScrollView(
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
                      showBottomAddSubscription(trainee);
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
