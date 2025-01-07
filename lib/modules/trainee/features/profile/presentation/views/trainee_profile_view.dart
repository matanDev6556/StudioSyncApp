import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/router/app_router.dart';
import 'package:studiosync/core/presentation/router/routes.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/core/presentation/utils/const.dart';
import 'package:studiosync/core/presentation/utils/validations.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/my_trainer_controller.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/widgets/my_trainer_widget.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_container.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_dropdown.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_text_field.dart';
import 'package:studiosync/core/presentation/widgets/general/custome_bttn.dart';

class TraineeProfileView extends GetView<TraineeController> {
  TraineeProfileView({Key? key}) : super(key: key);

  void _handleSave() {
    if (controller.formKey.currentState!.validate()) {
      controller.saveTrainee();
    } else {
      Validations.showValidationSnackBar(
          'Fill the requierd fields!', AppStyle.backGrey3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MyTrainerController myTrainerController = Get.find();

    return Obx(() {
      return Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
          children: [
            _buildSectionTitle('About me'),
            SizedBox(height: 16.h),
            _buildTextField(
              icon: Icons.person,
              hintText: "Name",
              initialValue: controller.trainee.value!.userFullName,
              onChanged: (newVal) => controller.updateLocalTrainee(
                  controller.trainee.value!.copyWith(userFullName: newVal)),
              validator: (val) => Validations.validateEmptey(val, 'Name'),
            ),
            SizedBox(height: 16.h),
            _buildTextField(
              icon: Icons.email,
              hintText: "Email",
              initialValue: controller.trainee.value!.userEmail,
              onChanged: (newVal) => controller.updateLocalTrainee(
                  controller.trainee.value!.copyWith(userEmail: newVal)),
              validator: (val) => Validations.validateEmail(val),
            ),
            SizedBox(height: 16.h),
            _buildTextField(
              icon: Icons.person,
              hintText: "Age",
              initialValue: controller.trainee.value!.userAge.toString(),
              onChanged: (newVal) => controller.updateLocalTrainee(
                controller.trainee.value!.copyWith(userAge: int.parse(newVal)),
              ),
              validator: (val) => Validations.validateEmptey(val, 'Age'),
            ),
            AppStyle.h(16.h),
            Obx(
              () => CustomDropDown<String>(
                icon: Icon(
                  Icons.location_on_sharp,
                  color: AppStyle.softOrange,
                ),
                color: Colors.white,
                textColor: AppStyle.softBrown,
                initialValue: controller.trainee.value!.userCity,
                onChanged: (newVal) => controller.updateLocalTrainee(
                    controller.trainee.value!.copyWith(userCity: newVal)),
                items: Const.cities,
                itemLabelBuilder: (city) => city,
              ),
            ),
            AppStyle.h(16.h),
            CustomButton(
              text: 'Save',
              fill: true,
              color: AppStyle.deepOrange,
              width: Get.width * 0.85,
              onTap: _handleSave,
              isLoading: controller.isLoading.value,
            ),
            AppStyle.h(15.h),
            _buildDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle('My trainer'),
                GestureDetector(
                  onTap: () => AppRouter.navigateTo(Routes.trainersList),
                  child: CustomContainer(
                    backgroundColor: AppStyle.softOrange.withOpacity(0.6),
                    child: Row(
                      children: [
                        Text(
                          'All',
                          style: TextStyle(
                            color: AppStyle.softBrown,
                            fontSize: 16.sp,
                          ),
                        ),
                        AppStyle.w(5.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 19.h,
                          color: AppStyle.softBrown,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            AppStyle.h(10.h),
            Obx(() => myTrainerController.myTrainer.value != null
                ? MyTrainerWidget(
                    trainerModel: myTrainerController.myTrainer.value,
                    onClick: () => AppRouter.navigateWithArgs(
                      Routes.trainerProfile,
                      myTrainerController.myTrainer.value,
                    ),
                  )
                : CustomContainer(
                    backgroundColor: Colors.red.withOpacity(0.2),
                    textColor: Colors.red,
                    padding: const EdgeInsets.all(10),
                    text: 'You didnt connected with trainer yet!',
                  )),
            _buildDivider(),
            _buildLogoutButton(),
          ],
        ),
      );
    });
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppStyle.softBrown,
        fontWeight: FontWeight.w600,
        fontSize: 18.sp,
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hintText,
    required String initialValue,
    required Function(String) onChanged,
    required String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return CustomTextField(
      icon: Icon(icon, color: AppStyle.softOrange),
      initialValue: initialValue,
      hintText: hintText,
      hintColor: AppStyle.softBrown.withOpacity(0.6),
      fill: true,
      color: Colors.white,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      textStyle: TextStyle(fontSize: 16.sp, color: AppStyle.softBrown),
    );
  }

  Widget _buildDivider() {
    return Divider(
      thickness: 1,
      color: AppStyle.backGrey2,
    );
  }

  Widget _buildLogoutButton() {
    return TextButton.icon(
      onPressed: () => controller.logout(),
      icon: Icon(Icons.logout, color: Colors.redAccent, size: 24.sp),
      label: Text(
        'Logout',
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
