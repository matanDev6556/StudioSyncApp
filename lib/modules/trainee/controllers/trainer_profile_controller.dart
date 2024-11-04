import 'package:get/get.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/controllers/trainee_controller.dart';
import 'package:studiosync/shared/models/request_model.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';
import 'package:url_launcher/url_launcher.dart';

class TrainerProfileController extends GetxController {
  final FirestoreService firestoreService;
  final TraineeController traineeController = Get.find();

  TrainerProfileController({
    required this.firestoreService,
   
  });

  Rx<TrainerModel?> myTrainer = Rx<TrainerModel?>(null);
  final isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    fetchMyTrainer(traineeController.trainee.value!.trainerID);
  }

  bool isMyTrainer(String trainerID) {
    return traineeController.trainee.value!.trainerID == trainerID;
  }

  Future<void> fetchMyTrainer(String trainerID) async {
    isLoading.value = true;
    var trainerMap = await firestoreService.getDocument('trainers', trainerID);
    if (trainerMap != null) {
      myTrainer.value = TrainerModel.fromJson(trainerMap);
      myTrainer.refresh();
    }
    isLoading.value = false;
  }

  Future<void> sendRequest(String trainerID) async {
    isLoading.value = true;

    // if trainee already connected to trainer first he need to disconect
    if (myTrainer.value != null) {
      Get.snackbar('Error', 'First disconnect from your trainer!');
      return;
    }

    final traineeID = traineeController.trainee.value!.userId;

    // בדיקה אם בקשה כבר קיימת
    final isRequestExists = await checkIfRequestExists(traineeID, trainerID);
    if (isRequestExists) {
      Get.snackbar('Request', 'Request already sent!');
      isLoading.value = false;
      return;
    }

    // יצירת בקשה חדשה
    final request = RequestModel(traineeID: traineeID, trainerID: trainerID);
    await firestoreService.addNastedDocument(
        'trainers', trainerID, 'requests', request.id, request.toMap());

    isLoading.value = false;
  }

  Future<bool> checkIfRequestExists(String traineeID, String trainerID) async {
    final existingRequest = await firestoreService.getDocument(
        'trainers/$trainerID/requests', traineeID);
    return existingRequest != null;
  }

  Future<void> disconnectTrainer(String trainerID) async {
    isLoading.value = true;

    final traineeId = traineeController.trainee.value!.userId;

    // reset fields that show the trainee connect to trainer
    final updatedTrainee =
        traineeController.trainee.value!.copyWith(trainerID: "");
    updatedTrainee.subscription = null;
    updatedTrainee.startWorOutDate = null;

    // move the trainee doc to general trainees coll
    await firestoreService.createDocument('trainees',
        traineeController.trainee.value!.userId, updatedTrainee.toMap());

    // מחיקת המתאמן ממאגר המתאמנים של המאמן
    await firestoreService.deleteDocumentAndSubcollections(
      'trainers/$trainerID/trainees',
      traineeId,
      ['workouts'],
    );

    // עדכון מסד הנתונים הכללי להסרת ה-trainerID
    await firestoreService.updateDocument('AllTrainees', traineeId, {
      'trainerID': '',
    });

    isLoading.value = false;

    myTrainer.value = null;
    traineeController.trainee.value = updatedTrainee;

    Get.back();
  }

  Future<int> countTraineesOfTrainer(String trainerID) async {
    return await firestoreService
        .countDocumentsInCollection('trainers/$trainerID/trainees');
  }

  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
