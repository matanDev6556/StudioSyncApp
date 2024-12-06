import 'package:get/get.dart';
import 'package:studiosync/modules/auth/controllers/signup_controller.dart';
import 'package:studiosync/modules/trainer/models/price_tier_model.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';

class SignUpTrainerController extends SignUpController {
  SignUpTrainerController(
      {required super.authService,
      required super.firestoreService,
      required super.storageServices});
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

  // Methods to update trainer-specific fields

  void updateAbout(String val) => about.value = val;

  void updateInstegramLing(String val) => instagramLink.value = val;

  void addPrice() {
    if (description.isNotEmpty && price >= 0) {
      var updatedPrices = List<PriceTier>.from(priceList);
      updatedPrices.insert(
          0, PriceTier(description: description.value, price: price.value));
      priceList.value = updatedPrices;
    }
    price.value = 0;
    description.value = '';
  }

  void deletePrice(PriceTier priceTier) {
    var updatedPrices = List<PriceTier>.from(priceList);
    updatedPrices.remove(priceTier);
    priceList.value = updatedPrices;
  }

  void addLocation(String location) {
    if (location.isNotEmpty) {
      var updatedLocations = List<String>.from(locationsList);
      updatedLocations.insert(0, location);

      locationsList.value = updatedLocations;

      this.location.value = '';
    }
  }

  void deleteLocation(int index) {
    var updatedLocations = List<String>.from(locationsList);
    updatedLocations.removeAt(index);

    locationsList.value = updatedLocations;
  }

  void addService() {
    if (service.isNotEmpty) {
      var updatedServices = List<String>.from(lessonsTypeList);

      updatedServices.insert(0, service.value);

      lessonsTypeList.value = updatedServices;

      service.value = '';
    }
  }

  void deleteService(int index) {
    var updatedServices = List<String>.from(lessonsTypeList);
    updatedServices.removeAt(index);

    lessonsTypeList.value = updatedServices;
  }

  void addSubTrainer() {
    if (subTrainerName.isNotEmpty) {
      var updatedSubTrainers = List<String>.from(coachesList);

      updatedSubTrainers.insert(0, subTrainerName.value);

      coachesList.value = updatedSubTrainers;

      subTrainerName.value = '';
    }
  }

  void deleteSubTrainer(int index) {
    var updatedSubTrainers = List<String>.from(coachesList);
    updatedSubTrainers.removeAt(index);

    coachesList.value = updatedSubTrainers;
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

      // auth user in
      final user = await authService.signUpWithEmailAndPassword(
        email.value,
        password.value,
      );

      // save in the db
      if (user != null) {
        await firestoreService.setDocument(
          'trainers',
          user.uid,
          newTrainer.copyWith(id: user.uid).toMap(),
        );
      }
    } else {
      print('Form validation failed');
    }
  }
}
