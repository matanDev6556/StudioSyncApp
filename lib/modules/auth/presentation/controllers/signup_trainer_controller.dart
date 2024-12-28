import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/router/app_router.dart';
import 'package:studiosync/core/presentation/router/routes.dart';
import 'package:studiosync/core/presentation/utils/validations.dart';
import 'package:studiosync/modules/auth/domain/usecases/signup_trainer_usecase.dart';
import 'package:studiosync/modules/auth/presentation/controllers/shared_signup_controller.dart';
import 'package:studiosync/modules/trainer/models/price_tier_model.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';

class SignUpTrainerController extends AbstractSignUpController {
  final SignUpTrainerUseCase _signUpTrainerUseCase;

  SignUpTrainerController({
    required super.pickImageUseCase,
    required SignUpTrainerUseCase signUpTrainerUseCase,
  }) : _signUpTrainerUseCase = signUpTrainerUseCase;

  // Trainer-specific fields
  RxList<String> imageUrls = <String>[].obs;
  RxList<PriceTier> priceList = <PriceTier>[].obs;
  RxList<String> coachesList = <String>[].obs;
  RxList<String> locationsList = <String>[].obs;
  RxList<String> lessonsTypeList = <String>[].obs;
  RxString about = ''.obs;
  RxString instagramLink = ''.obs;

  var description = ''.obs;
  var price = (-1.0).obs;
  var location = ''.obs;
  var service = ''.obs;
  var subTrainerName = ''.obs;

  void updateAbout(String val) => about.value = val;
  void updateInstegramLing(String val) => instagramLink.value = val;

  // Methods to update trainer-specific fields

  void addToList<T>(RxList<T> list, T item) {
    if (item != null) {
      list.insert(0, item);
    }
  }

  void removeFromList<T>(RxList<T> list, int index) {
    list.removeAt(index);
  }

  void addPrice() {
    if (description.isNotEmpty && price >= 0) {
      addToList(priceList,
          PriceTier(description: description.value, price: price.value));
    }
    price.value = 0;
    description.value = '';
  }

  void addLocation(String location) {
    if (location.isNotEmpty) {
      addToList(locationsList, location);
      this.location.value = '';
    }
  }

  void addService() {
    if (service.isNotEmpty) {
      addToList(lessonsTypeList, service.value);
      service.value = '';
    }
  }

  void addSubTrainer() {
    if (subTrainerName.isNotEmpty) {
      addToList(coachesList, subTrainerName.value);
      subTrainerName.value = '';
    }
  }

  void deletePrice(int index) {
    removeFromList(priceList, index);
  }

  void deleteLocation(int index) {
    removeFromList(locationsList, index);
  }

  void deleteService(int index) {
    removeFromList(lessonsTypeList, index);
  }

  void deleteSubTrainer(int index) {
    removeFromList(coachesList, index);
  }

  // Validation and submission
  @override
  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  // Submit logic
  @override
  void submit() async {
    if (validateForm()) {
      final newTrainer = TrainerModel(
        userFullName: fullName.value,
        userEmail: email.value,
        userPhone: phone.value,
        userCity: city.value,
        userAge: age.value.toInt(),
        about: about.value,
        priceList: priceList,
        imageUrls: imageUrls,
        coachesList: coachesList,
        locationsList: locationsList,
        lessonsTypeList: lessonsTypeList,
        instagramLink: instagramLink.value,
        isTrainer: true,
      );

      try {
        await _signUpTrainerUseCase.execute(
            newTrainer, email.value, password.value);
      } catch (e) {
        Validations.showValidationSnackBar(e.toString(), Colors.red);
        AppRouter.navigateTo(Routes.widgetTree);
      }
    } else {
      Validations.showValidationSnackBar('Form validation failed!', Colors.red);
    }
  }
}
