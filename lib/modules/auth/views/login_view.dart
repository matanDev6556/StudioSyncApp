import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/modules/auth/const_auth.dart';
import 'package:studiosync/modules/auth/controllers/login_controller.dart';
import 'package:studiosync/modules/auth/widgets/app_bar.dart';
import 'package:studiosync/core/shared/widgets/custom_text_field.dart';
import 'package:studiosync/core/shared/widgets/custome_bttn.dart';
import 'package:studiosync/core/router/routes.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = 0.4.h;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * height),
        child: AppBarAuth(
          context: context,
          toolBarHeight: MediaQuery.of(context).size.height * height,
          back: false,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 20.w,
          right: 20.w,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppStyle.h(20.h),
                Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 30.sp,
                      color: AppStyle.deepBlackOrange,
                    ),
                  ),
                ),
                AppStyle.h(20.h),
                CustomTextField(
                  icon: Icon(
                    Icons.email,
                    color: AppStyle.backGrey3,
                  ),
                  hintText: "Email",
                  hintColor: AppStyle.backGrey3,
                  fill: false,
                  color: AppStyle.deepOrange,
                  maxLines: 1,
                  onChanged: (newVal) {
                    controller.setEmail(newVal);
                  },
                  validator: (valid) {
                    return Validations.validateEmail(valid);
                  },
                ),
                AppStyle.h(15.h),
                CustomTextField(
                  icon: Icon(
                    Icons.password,
                    color: AppStyle.backGrey3,
                  ),
                  hintText: "Password",
                  hintColor: AppStyle.backGrey3,
                  fill: false,
                  color: AppStyle.deepOrange,
                  maxLines: 1,
                  onChanged: (newVal) {
                    controller.setPassword(newVal);
                  },
                  validator: (valid) {
                    return Validations.validateEmptey(valid, 'Password');
                  },
                ),
                AppStyle.h(15.h),
                Obx(() {
                  if (controller.loginStatus.value == LoginStatus.submitting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return CustomButton(
                    text: 'Login',
                    fill: true,
                    color: AppStyle.deepOrange,
                    width: MediaQuery.of(context).size.width * 0.85,
                    onTap: () {
                      controller.login();
                    },
                  );
                }),
                AppStyle.h(15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "New user? ",
                      style: TextStyle(
                        color: AppStyle.backGrey3,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.signUpAs),
                      child: Text(
                        "Sign Up.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppStyle.deepBlackOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
