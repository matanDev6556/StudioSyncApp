import 'package:flutter/foundation.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_trainee_repository.dart';

class GetTraineeDataUseCasee {
  final ITraineeRepository _iTraineeRepository;

  GetTraineeDataUseCasee({required ITraineeRepository iTraineeRepository})
      : _iTraineeRepository = iTraineeRepository;

  Future<TraineeModel?> call(String uid) async {
    try {
      return await _iTraineeRepository.getTraineeData(uid);
    } catch (e) {
      debugPrint("שגיאה בקבלת נתוני המתמחה: $e");
      return null;
    }
  }
}