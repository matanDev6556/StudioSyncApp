import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/presentation/router/app_router.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/auth/presentation/widgets/app_bar.dart';
import 'package:studiosync/core/presentation/widgets/general/custome_bttn.dart';
import 'package:studiosync/core/presentation/router/routes.dart';

class SignUpAsView extends StatelessWidget {
  const SignUpAsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(AppStyle.getScreenHeight() * 0.4), // גובה מותאם
        child: AppBarAuth(
          context: context,
          toolBarHeight: AppStyle.getScreenHeight() * 0.4,
          back: false,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30.h),
                  Text(
                    'Sign-Up',
                    style: TextStyle(
                      fontSize: 30.sp,
                      color: AppStyle.deepBlackOrange,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 25.h),
                  CustomButton(
                    text: 'Sign as Trainer',
                    fill: true,
                    color: AppStyle.deepOrange,
                    width: MediaQuery.of(context).size.width * 0.85,
                    onTap: () => AppRouter.navigateTo(Routes.signUpTrainer),
                  ),
                  SizedBox(height: 15.h),
                  CustomButton(
                    text: 'Sign as Trainee',
                    fill: false,
                    color: AppStyle.deepOrange,
                    width: MediaQuery.of(context).size.width * 0.85,
                    onTap: () => AppRouter.navigateTo(Routes.signUpTrainee),
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already signed up?",
                        style: TextStyle(
                          color: AppStyle.darkGrey,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      InkWell(
                        onTap: () => AppRouter.navigateTo(Routes.login),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: AppStyle.deepBlackOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),
                ],
              ),
            ),
          ),
          _buildTermsAndConditions(context), // ה-terms בתחתית
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "By creating an account, you are agreeing to our\n",
          style: TextStyle(color: AppStyle.backGrey3, fontSize: 12.sp),
          children: [
            TextSpan(
                text: "Terms & Conditions ",
                style: const TextStyle(fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                // ניתן להוסיף כאן onTap
                ),
            const TextSpan(text: "and "),
            TextSpan(
                text: "Privacy Policy! ",
                style: const TextStyle(fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                // ניתן להוסיף כאן onTap
                ),
          ],
        ),
      ),
    );
  }
}
