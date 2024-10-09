import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/auth/widgets/app_bar.dart';
import 'package:studiosync/shared/widgets/custome_bttn.dart';
import 'package:studiosync/core/router/routes.dart';

class SignUpAsView extends StatelessWidget {
  const SignUpAsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.5),
        child: AppBarAuth(
          context: context,
          toolBarHeight: MediaQuery.of(context).size.height * 0.5,
          back: false,
        ),
      ),
      body: Column(
        children: [
          AppStyle.h(30.h),
          Text(
            'Sign-Up',
            style: TextStyle(
              fontSize: 30.sp,
              color: AppStyle.deepBlackOrange,
              fontWeight: FontWeight.w400,
            ),
          ),
          AppStyle.h(25.h),
          CustomButton(
            text: 'Sign as Trainer',
            fill: true,
            color: AppStyle.deepOrange,
            width: MediaQuery.of(context).size.width * 0.85,
            onTap: () => Get.toNamed(Routes.signUpTrainer),
          ),
          AppStyle.h(15.h),
          CustomButton(
            text: 'Sign as Trainee',
            fill: false,
            color: AppStyle.deepOrange,
            width: MediaQuery.of(context).size.width * 0.85,
            onTap: () => Get.toNamed(Routes.signUpTrainee),
          ),
          AppStyle.h(15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already sign up?",
                style: TextStyle(
                  color: AppStyle.darkGrey,
                ),
              ),
              AppStyle.w(8.h),
              InkWell(
                onTap: () => Get.toNamed(Routes.login),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: AppStyle.deepBlackOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildTermsAndConditions(context),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25.w),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "By creating an account, you are agreeing to our\n",
          style: TextStyle(color: AppStyle.backGrey3),
          children: [
            TextSpan(
                text: "Terms & Conditions ",
                style: const TextStyle(fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                /*
                ..onTap = () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return PolicyDialog(
                          mdFileName: 'terms_of_use.md');
                    },
                  );
                },
                */
                ),
            const TextSpan(text: "and "),
            TextSpan(
                text: "Privacy Policy! ",
                style: const TextStyle(fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                /*
                ..onTap = () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return PolicyDialog(
                          mdFileName: 'privacy_policy.md');
                    },
                  );
                },
                */
                ),
          ],
        ),
      ),
    );
  }
}
