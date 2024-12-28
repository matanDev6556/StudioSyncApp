import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/domain/usecases/pick_image_usecase.dart';

import 'package:studiosync/core/presentation/utils/validations.dart';
import 'package:uuid/uuid.dart';

abstract class AbstractSignUpController extends GetxController {
  final PickImageUseCase _pickImageUseCase;

  AbstractSignUpController({required PickImageUseCase pickImageUseCase})
      : _pickImageUseCase = pickImageUseCase;

  // Shared fields
  var userId = const Uuid().v4();
  RxString email = ''.obs;
  RxString password = ''.obs;
  RxString fullName = ''.obs;
  RxString phone = ''.obs;
  RxString city = ''.obs;
  RxDouble age = 0.0.obs;
  RxString imgPath = ''.obs;

  var isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  // Image selection logic
  void pickImage() async {
    try {
      isLoading.value = true;
      final imgUrl = await _pickImageUseCase(userId);
      if (imgUrl != null) {
        updateImgUrl(imgUrl);
      }
    } catch (e) {
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  // Methods to update fields
  void updateEmail(String val) => email.value = val;
  void updatePassword(String val) => password.value = val;
  void updateFullName(String val) => fullName.value = val;
  void updatePhone(String val) => phone.value = val;
  void updateCity(String val) => city.value = val;
  void updateAge(double val) => age.value = val;
  void updateImgUrl(String val) => imgPath.value = val;

  // Validation
  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  // Abstract method for submission
  void submit();
}
