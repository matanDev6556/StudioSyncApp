import 'package:studiosync/modules/trainee/models/subscriptions/by_date_model.dart';
import 'package:studiosync/modules/trainee/models/subscriptions/by_total_trainings_model.dart';
import 'package:studiosync/modules/trainee/models/subscriptions/subscription_model.dart';
import 'package:studiosync/core/shared/models/user_model.dart';
import 'package:studiosync/modules/trainee/models/workout.dart';

class TraineeModel extends UserModel {
  String? trainerID;
  DateTime? startWorOutDate;
  List<WorkoutModel>? workouts;
  Subscription? subscription;

  TraineeModel({
    super.id,
    required super.imgUrl,
    required super.userFullName,
    required super.isTrainer,
    required super.userEmail,
    required super.userAge,
    required super.userCity,
    required super.userPhone,
    this.startWorOutDate,
    this.workouts = const <WorkoutModel>[],
    this.trainerID = '',
    this.subscription,
  });

  @override
  TraineeModel copyWith({
    String? id,
    String? imgUrl,
    String? userFullName,
    bool? isTrainer,
    String? userEmail,
    String? userPass,
    int? userAge,
    String? userCity,
    String? userPhone,
    DateTime? startWorkOutDate,
    List<double>? weights,
    List<WorkoutModel>? workout,
    String? trainerID,
    Subscription? subscription,
  }) {
    return TraineeModel(
      id: id ?? this.userId,
      imgUrl: imgUrl ?? this.imgUrl,
      userFullName: userFullName ?? this.userFullName,
      isTrainer: isTrainer ?? this.isTrainer,
      userEmail: userEmail ?? this.userEmail,
      userAge: userAge ?? this.userAge,
      userCity: userCity ?? this.userCity,
      userPhone: userPhone ?? this.userPhone,
      startWorOutDate: startWorkOutDate ?? startWorOutDate,
      workouts: workout ?? this.workouts,
      trainerID: trainerID ?? this.trainerID,
      subscription: subscription ?? this.subscription,
    );
  }

  factory TraineeModel.fromJson(Map<String, dynamic> json) {
    List<WorkoutModel>? workoutList = (json['workout'] as List<dynamic>)
        .map((e) => WorkoutModel.fromJson(e as Map<String, dynamic>))
        .toList();
    Map<String, dynamic>? subJson = json['subscription'];
    Subscription? subscription;

    if (subJson != null) {
      switch (subJson['subscriptionType']) {
        case 'byDate':
          subscription = SubscriptionByDate.fromJson(subJson);
          break;

        case 'byTotalTrainings':
          subscription = SubscriptionByTotalTrainings.fromJson(subJson);
          break;
      }
    }

    return TraineeModel(
      id: json['id'],
      imgUrl: json['imgUrl'],
      userFullName: json['userFullName'],
      isTrainer: json['isTrainer'],
      userEmail: json['userEmail'],
      userAge: json['userAge'],
      userCity: json['userCity'],
      userPhone: json['userPhone'],
      startWorOutDate: json['startWorOutDate'] != null
          ? DateTime.parse(json['startWorOutDate'])
          : null,
      workouts: workoutList,
      trainerID: json['trainerID'],
      subscription: subscription,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> traineeModelData = {};

    traineeModelData['id'] = userId;
    traineeModelData['imgUrl'] = imgUrl;
    traineeModelData['userFullName'] = userFullName;

    traineeModelData['isTrainer'] = isTrainer;
    traineeModelData['userEmail'] = userEmail;
    traineeModelData['userAge'] = userAge;
    traineeModelData['userCity'] = userCity;
    traineeModelData['userPhone'] = userPhone;

    traineeModelData['startWorOutDate'] = startWorOutDate?.toIso8601String();

    traineeModelData['subscription'] =
        subscription == null ? null : subscription?.toMap();

    if (workouts != null) {
      traineeModelData['workout'] = workouts!.map((e) => e.toMap()).toList();
    }
    traineeModelData['trainerID'] = trainerID;

    return traineeModelData;
  }

  //when trainee disconnected from Trainer we need to reset this data
  TraineeModel resetWorkout() {
    TraineeModel traineeModel = copyWith(
      trainerID: '',
      workout: [],
      weights: [],
    );
    // do this because i cant copy with null value
    traineeModel.subscription = null;
    return traineeModel;
  }

  String getWeightTrendMessage() {
    if (workouts != null) {
      if (workouts!.length < 2) {
        return "Not enough data";
      }

      // סדר את רשימת האימונים לפי התאריך
      workouts!.sort((a, b) => a.dateScope!.compareTo(b.dateScope!));

      double initialWeight = workouts!.first.weight; // משקל התחלתי
      double latestWeight = workouts!.last.weight; // משקל עדכני
      double weightDifference = latestWeight - initialWeight;

      if (latestWeight > initialWeight) {
        return "You've gained ${weightDifference.toStringAsFixed(2)} kg.";
      } else if (latestWeight < initialWeight) {
        return "You've lost ${(-weightDifference).toStringAsFixed(2)} kg.";
      } else {
        return "Your weight remains unchanged.";
      }
    }
    return "Not enough data";
  }

  bool isActive() {
    // if subscription null the trainee not avtice,
    // and if subscription != null check the isActive of the spetsific subscription
    return subscription?.isActive() ?? false;
  }
}
