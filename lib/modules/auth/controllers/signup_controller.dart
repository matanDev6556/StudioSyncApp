import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';

import 'package:studiosync/core/services/interfaces/i_auth_service.dart';
import 'package:studiosync/core/services/interfaces/i_storage_service.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:uuid/uuid.dart';

class SignUpController extends GetxController {
  final IAuthService authService;
  final FirestoreService firestoreService;
   final IStorageService storageService;

  SignUpController({
    required this.authService,
    required this.firestoreService,
    required this.storageService,
  });

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

  void pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);

        isLoading.value = true;
        final imgUrl = await storageService.uploadImage(
            imageFile, '$userId/${const Uuid().v4()}.jpg');

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

  // Validation and submission
  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void submit() async {
    if (validateForm()) {
      final newTrainee = TraineeModel(
        id: userId,
        userFullName: fullName.value,
        userEmail: email.value,
        userPhone: phone.value,
        userCity: city.value,
        userAge: age.value.toInt(),
        imgUrl: imgPath.value,
        isTrainer: false,
      );

      final user = await authService.signUpWithEmailAndPassword(
        email.value,
        password.value,
      );
      if (user != null) {
        await firestoreService.setDocument(
          'trainees',
          user.uid,
          newTrainee.copyWith(id: user.uid).toMap(),
        );

        await firestoreService.setDocument(
          'AllTrainees',
          user.uid,
          {
            'id': user.uid,
            'trainerID': newTrainee.trainerID,
          },
        );
      }
    }
  }
}
