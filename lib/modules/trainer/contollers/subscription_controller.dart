import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/data/services/firebase/firestore_service.dart';
import 'package:studiosync/core/presentation/utils/validations.dart';
import 'package:studiosync/modules/trainee/models/subscriptions/by_date_model.dart';
import 'package:studiosync/modules/trainee/models/subscriptions/by_total_trainings_model.dart';
import 'package:studiosync/modules/trainee/models/subscriptions/subscription_model.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/contollers/trainees_controller.dart';

enum SubscriptionType { byDate, byTotalTrainings }

class SubscriptionController extends GetxController {
  final FirestoreService firestoreService;

  SubscriptionController(this.firestoreService);

  // init deafult subs
  var subscriptionByTotal = SubscriptionByTotalTrainings(
    totalTrainings: 0,
    usedTrainings: 0,
  ).obs;

  var subscriptionByDate = SubscriptionByDate(
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 30)),
    monthlyTrainingLimit: 0,
    usedMonthlyTraining: 0,
    currentMonth: DateTime.now().month,
  ).obs;

  var selectedType = SubscriptionType.byDate.obs;

  var isLoading = false.obs;

  //---Shared functions--

  void initSub(
    Subscription? sub,
  ) {
    if (sub == null) return;
    final type = getSubType(sub.subscriptionType);

    if (type == SubscriptionType.byDate) {
      final subscription = sub as SubscriptionByDate;
      subscriptionByDate.value = subscription;
      selectedType.value = SubscriptionType.byDate;
    } else {
      final subscription = sub as SubscriptionByTotalTrainings;
      subscriptionByTotal.value = subscription;
      selectedType.value = SubscriptionType.byTotalTrainings;
    }
  }

  SubscriptionType? getSubType(String subType) {
    switch (subType) {
      case 'byTotalTrainings':
        return SubscriptionType.byTotalTrainings;
      case 'byDate':
        return SubscriptionType.byDate;

      default:
        return null;
    }
  }

  void updateSelectedType(SubscriptionType type) {
    selectedType.value = type;
    selectedType.refresh();
  }

  void updateSubscriptionByTotal(SubscriptionByTotalTrainings newSubscription) {
    subscriptionByTotal.value = newSubscription;
    subscriptionByTotal.refresh();
  }

  void updateSubscriptionByDate(SubscriptionByDate newSubscription) {
    subscriptionByDate.value = newSubscription;
    subscriptionByDate.refresh();
  }

  // פונקציה לשמור שינויים במידע המנוי של המתאמן
  void save(TraineeModel trainee) async {
    try {
      // מציאת הקונטרולר של המתאמנים כדי לעדכן את הרשימה שלהם
      final traineesController = Get.find<TraineesController>();

      // הפעלת מצב טעינה
      isLoading.value = true;
      // יצירת מודל מתאמן מעודכן עם המידע החדש
      TraineeModel updatedTrainee;
      // בדיקה איזה סוג מנוי נבחר ועדכון המודל בהתאם
      if (selectedType.value == SubscriptionType.byDate) {
        updatedTrainee =
            trainee.copyWith(subscription: subscriptionByDate.value);
      } else {
        updatedTrainee =
            trainee.copyWith(subscription: subscriptionByTotal.value);
      }
      // עדכון המסמך של המתאמן בשירות הפיירבייס
      await firestoreService.setDocument(
        'trainers/${updatedTrainee.trainerID}/trainees',
        updatedTrainee.userId,
        updatedTrainee.toMap(),
      );

      // עדכון הרשימה המסוננת של המתאמנים עם המידע החדש
      traineesController.filteredTraineesList.value = traineesController
          .filteredTraineesList
          .map((t) => t.userId == trainee.userId ? updatedTrainee : t)
          .toList();
      // רענון הרשימה המלאה של המתאמנים
      traineesController.traineesList.refresh();
    } catch (e) {
      // הצגת הודעת שגיאה במקרה של שגיאה
      Validations.showValidationSnackBar(e.toString(), Colors.red);
    } finally {
      // הסרת מצב הטעינה
      isLoading.value = false;
    }

    // סגירת המסך הנוכחי
    Get.back();
  }

  void cancleSub(TraineeModel trainee) async {
    final TraineeModel updatetrainee = trainee;
    updatetrainee.subscription = null;
    isLoading.value = true;
    await firestoreService.setDocument(
      'trainers/${updatetrainee.trainerID}/trainees',
      updatetrainee.userId,
      updatetrainee.toMap(),
    );
    isLoading.value = false;
  }

  //----ByTotal functions

  void updateExpredDate(bool isExpired) {
    if (!isExpired) {
      final updatedSub = subscriptionByTotal.value;
      updatedSub.expiredDate = null;

      updateSubscriptionByTotal(updatedSub);
    } else {
      updateSubscriptionByTotal(
          subscriptionByTotal.value.copyWith(expiredTime: DateTime.now()));
    }
  }
}
