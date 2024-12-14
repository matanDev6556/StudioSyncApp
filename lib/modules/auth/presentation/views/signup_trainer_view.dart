import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/auth/presentation/controllers/signup_trainer_controller.dart';
import 'package:studiosync/modules/auth/presentation/widgets/signup_fields.dart';
import 'package:studiosync/modules/auth/presentation/widgets/signup_trainer_fields.dart';

class SignUpTrainerView extends StatelessWidget {
  const SignUpTrainerView({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpTrainerController controller =
        Get.find<SignUpTrainerController>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppStyle.backGrey,
      body: Obx(() => GeneralSignUpForm(
            trainerForm: SignUpTrainerFields(),
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
            isTrainer: true,
          )),
    );
  }
}
