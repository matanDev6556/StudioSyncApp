import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/auth/presentation/controllers/signup_trainee_controller.dart';
import 'package:studiosync/modules/auth/presentation/widgets/signup_fields.dart';

class SignUpTraineeView extends StatelessWidget {
  const SignUpTraineeView({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpTraineeController controller =
        Get.find<SignUpTraineeController>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppStyle.backGrey,
      body: Obx(
        () => GeneralSignUpForm(
          trainerForm: null,
          formKey: controller.formKey,
          onTapSelectImg: controller.pickImage,
          isImgLoading: controller.isLoading.value,
          imgPath: controller.imgPath.value,
          onChangeEmail: controller.updateEmail,
          onChangePass: controller.updatePassword,
          onChangeFullName: controller.updateFullName,
          onChangePhone: controller.updatePhone,
          onChangeCity: controller.updateCity,
          onChangeAge: controller.updateAge,
          onTapNext: controller.submit,
          isTrainer: false,
        ),
      ),
    );
  }
}
