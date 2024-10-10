import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/core/utils/const.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/shared/widgets/custom_text_field.dart';
import 'package:studiosync/shared/widgets/custome_dropdown.dart';
import 'package:studiosync/shared/widgets/select_image.dart';

class SharedSignUpFields extends StatelessWidget {
  final String imgPath;
  final bool isImgLoading;
  final Function onTapSelectImg;
  final Function(String) onChangeEmail;
  final Function(String) onChangePass;
  final Function(String) onChangeFullName;
  final Function(String) onChangePhone;
  final Function(String) onChangeCity;
  final Function(double) onChangeAge;

  const SharedSignUpFields({
    super.key,
    required this.imgPath,
    required this.isImgLoading,
    required this.onTapSelectImg,
    required this.onChangeEmail,
    required this.onChangePass,
    required this.onChangeFullName,
    required this.onChangePhone,
    required this.onChangeCity,
    required this.onChangeAge,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppStyle.h(15.h),
        SelectImageWidget(
          onTap: () => onTapSelectImg(),
          imagePath: imgPath,
        ),
        AppStyle.h(25.h),
        CustomTextField(
          icon: const Icon(Icons.email),
          hintText: 'Email',
          hintColor: AppStyle.backGrey3,
          fill: true,
          color: AppStyle.backGrey2,
          maxLines: 1,
          onChanged: (newVal) => onChangeEmail(newVal),
          validator: (valid) {
            return Validations.validateEmail(valid);
          },
        ),
        AppStyle.h(15.h),
        CustomTextField(
          icon: const Icon(Icons.password),
          hintText: 'Password',
          hintColor: AppStyle.backGrey3,
          fill: true,
          color: AppStyle.backGrey2,
          maxLines: 1,
          onChanged: (newVal) => onChangePass(newVal),
          validator: (valid) {
            return Validations.validateEmptey(valid, 'Password');
          },
        ),
        AppStyle.h(15.h),
        Divider(
          thickness: 1.h,
          color: AppStyle.backGrey2,
        ),
        AppStyle.h(15.h),
        CustomTextField(
          icon: const Icon(Icons.person),
          hintText: 'Full name',
          hintColor: AppStyle.backGrey3,
          fill: true,
          color: AppStyle.backGrey2,
          maxLines: 1,
          onChanged: (newVal) => onChangeFullName(newVal),
          validator: (valid) => Validations.validateEmptey(valid, 'Full name'),
        ),
        AppStyle.h(15.h),
        CustomTextField(
          icon: const Icon(Icons.phone),
          hintText: 'Phone',
          hintColor: AppStyle.backGrey3,
          fill: true,
          color: AppStyle.backGrey2,
          maxLines: 1,
          onChanged: (newVal) => onChangePhone(newVal),
          validator: (valid) {
            return Validations.validOnlyNumbers(valid ?? '', 'Phone');
          },
        ),
        AppStyle.h(15.h),
        CustomDropDown<String>(
          icon: const Icon(Icons.location_on_rounded),
          items: Const.cities,
          itemLabelBuilder: (city) => city,
          onChanged: (value) => onChangeCity(value!),
        ),
        AppStyle.h(15.h),
        CustomTextField(
          icon: const Icon(Icons.numbers),
          hintText: 'Age',
          hintColor: AppStyle.backGrey3,
          fill: true,
          color: AppStyle.backGrey2,
          maxLines: 1,
          onChanged: (newVal) => onChangeAge(double.tryParse(newVal) ?? 0),
          validator: (valid) {
            return Validations.validOnlyNumbers(valid ?? '', 'Age');
          },
        ),
        AppStyle.h(15.h),
      ],
    );
  }
}
