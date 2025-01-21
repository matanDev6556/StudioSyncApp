import 'package:flutter/foundation.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_trainee_repository.dart';

class GetTraineeDataUseCasee {
  final ITraineeRepository _iTraineeRepository;
  final IAuthRepository _iAuthRepository;

  GetTraineeDataUseCasee(
      {required ITraineeRepository iTraineeRepository,
      required IAuthRepository iAuthRepository})
      : _iTraineeRepository = iTraineeRepository,
        _iAuthRepository = iAuthRepository;

  Future<TraineeModel?> call() async {
    try {
      final uid = _iAuthRepository.userUid;
      return await _iTraineeRepository.getTraineeData(uid ?? '');
    } catch (e) {
      debugPrint("שגיאה בקבלת נתוני המתמחה: $e");
      return null;
    }
  }
}
