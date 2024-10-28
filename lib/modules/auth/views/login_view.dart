import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/modules/auth/const_auth.dart';
import 'package:studiosync/modules/auth/controllers/login_controller.dart';
import 'package:studiosync/modules/auth/widgets/app_bar.dart';
import 'package:studiosync/shared/widgets/custom_text_field.dart';
import 'package:studiosync/shared/widgets/custome_bttn.dart';
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
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppStyle.h(20.h),
                    Center(
                      child: Text(
                        'Login ',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppStyle.deepBlackOrange,
                        ),
                      ),
                    ),
                    AppStyle.h(30.h),
                    _buildLoginForm(),
                    AppStyle.h(20.h),
                    _buildLoginButton(),
                    AppStyle.h(20.h),
                    _buildSignUpLink(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppStyle.softOrange.withOpacity(0.1),
            Colors.white,
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        _buildTextField(
          icon: Icons.email,
          hintText: "Email",
          onChanged: controller.setEmail,
          validator: Validations.validateEmail,
        ),
        AppStyle.h(20.h),
        _buildTextField(
          icon: Icons.lock,
          hintText: "Password",
          onChanged: controller.setPassword,
          validator: (valid) => Validations.validateEmptey(valid, 'Password'),
          isPassword: true,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hintText,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CustomTextField(
        icon: Icon(icon, color: AppStyle.softOrange),
        hintText: hintText,
        hintColor: AppStyle.backGrey3,
        fill: true,
        color: Colors.white,
        maxLines: 1,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(() {
      if (controller.loginStatus.value == LoginStatus.submitting) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppStyle.softOrange),
          ),
        );
      }
      return CustomButton(
        text: 'Login',
        fill: true,
        color: AppStyle.deepBlackOrange,
        width: double.infinity,
        onTap: () {
          controller.login();
        },
      );
    });
  }

  Widget _buildSignUpLink() {
    return Row(
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
            "Sign Up",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppStyle.deepBlackOrange,
            ),
          ),
        ),
      ],
    );
  }
}
