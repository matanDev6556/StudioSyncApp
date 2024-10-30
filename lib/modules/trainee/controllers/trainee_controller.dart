import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/core/services/firebase/auth_service.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';
import 'package:studiosync/shared/models/request_model.dart';
import 'package:studiosync/shared/services/image_service.dart';
import 'package:url_launcher/url_launcher.dart';

class TraineeController extends GetxController {
  final ImageService imageService;
  final AuthService authService;
  final FirestoreService firestoreService;

  TraineeController({
    required this.authService,
    required this.firestoreService,
    required this.imageService,
  });

  Rx<TraineeModel?> trainee = Rx<TraineeModel?>(null);
  Rx<TrainerModel?> myTrainer = Rx<TrainerModel?>(null);

  final isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    fetchMyTrainer();
  }

  Future<int> countTraineesOfTrainer(String trainerID) async {
    return await firestoreService
        .countDocumentsInCollection('trainers/$trainerID/trainees');
  }

  bool isMyTrainer(String trainerID) {
    return trainee.value!.trainerID == trainerID;
  }

  void disconnectFromTrainer() async {
    // reset fields that show the trainee connect to trainer
    final updatedTrainee = trainee.value!.copyWith(trainerID: "");
    updatedTrainee.subscription = null;
    updatedTrainee.startWorOutDate = null;

    isLoading.value = true;
    // move the trainee doc to general trainees coll
    await firestoreService.createDocument(
        'trainees', trainee.value!.userId, updatedTrainee.toMap());

    // delete the trainee doc from trainees sub collection inside trainer
    await firestoreService.deleteDocumentAndSubcollections(
        'trainers/${trainee.value!.trainerID}/trainees',
        trainee.value!.userId, [
      'workouts',
    ]);
    // update the trainerID in the all trainees coll
    await firestoreService.updateDocument(
      'AllTrainees',
      trainee.value!.userId,
      {'id': trainee.value!.userId, 'trainerID': ""},
    );

    isLoading.value = false;

    // update myTrainer locally

    myTrainer.value = null;
    trainee.value = updatedTrainee;

    Get.back();
  }

  void sendRequestToTrainer(String trainerID) async {
    isLoading.value = true;

    // if trainee already connected to trainer first he need to disconect
    if (myTrainer.value != null) {
      Validations.showValidationSnackBar(
          'First disconnect from youre trainer!', Colors.red);
      return;
    }

    // check if the trainee already sent to this trainer request
    final isSentReq = await checkIfRequestExists(trainerID);

    if (isSentReq) {
      Validations.showValidationSnackBar(
          'You already sent for this trainer request!', Colors.red);
      return;
    }
    //create req
    final RequestModel req =
        RequestModel(traineeID: trainee.value!.userId, trainerID: trainerID);

    // add req to trainer as sub coll
    await firestoreService.addNastedDocument(
        'trainers', trainerID, 'requests', req.id, req.toMap());

    isLoading.value = false;
  }

  Future<bool> checkIfRequestExists(String trainerID) async {
    // בדיקה אם קיימת כבר בקשה באוסף
    final existingRequest = await firestoreService.getDocument(
        'trainers/$trainerID/requests', trainee.value!.userId);

    if (existingRequest != null) {
      return true;
    } else {
      return false;
    }
  }

  //TODO : move this function to trainer module because he need to confirm or not this connect
  void connectToTrainer(String trainerID) async {
    // add trainne to trainees sub coll

    final updatedTrainee = trainee.value!
        .copyWith(trainerID: trainerID, startWorkOutDate: DateTime.now());

    isLoading.value = true;
    await firestoreService.addNastedDocument(
      'trainers',
      trainerID,
      'trainees',
      trainee.value!.userId,
      updatedTrainee.toMap(),
    );

    // delete the trainee from general coll trainees
    await firestoreService.deleteDocument('trainees', trainee.value!.userId);

    // update trainerID in allTrainees coll
    await firestoreService.updateDocument(
      'AllTrainees',
      trainee.value!.userId,
      {'id': trainee.value!.userId, 'trainerID': trainerID},
    );

    isLoading.value = false;

    // update localy

    trainee.value = updatedTrainee;
    fetchMyTrainer();
  }

  void fetchMyTrainer() async {
    if (trainee.value!.trainerID.isNotEmpty) {
      var trainerMap = await firestoreService.getDocument(
          'trainers', trainee.value!.trainerID);
      if (trainerMap != null) {
        myTrainer.value = TrainerModel.fromJson(trainerMap);
      }
    }
  }

  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  void saveTraineeToDb() async {
    isLoading.value = true;
    await firestoreService.addNastedDocument(
        'trainers',
        trainee.value!.trainerID,
        'trainees',
        trainee.value!.userId,
        trainee.value!.toMap());
    isLoading.value = false;
  }

  Future<void> setNewProfileImg() async {
    isLoading.value = true;
    final imgUrl = await imageService.pickAndUploadImage(trainee.value!.userId);
    isLoading.value = false;
    if (imgUrl != null) {
      updateLocalTrainer(trainee.value!.copyWith(imgUrl: imgUrl));
    }
  }

  void updateLocalTrainer(TraineeModel updatedTrainee) {
    trainee.value = updatedTrainee;
    trainee.refresh();
  }

  void logout() async {
    await authService.signOut();
    Get.offAllNamed(Routes.login);
  }
}
