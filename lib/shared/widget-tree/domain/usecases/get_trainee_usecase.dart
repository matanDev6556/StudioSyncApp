import 'package:flutter/foundation.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/shared/widget-tree/domain/repositories/i_widget_tree_repository.dart';

class GetTraineeDataUseCase {
  final IWidgetTreeRepository _iWidgetTreeRepository;

  GetTraineeDataUseCase({required IWidgetTreeRepository iWidgetTreeRepository})
      : _iWidgetTreeRepository = iWidgetTreeRepository;

  Future<TraineeModel?> call(String uid) async {
    try {
      return await _iWidgetTreeRepository.getTraineeData(uid);
    } catch (e) {
      debugPrint("שגיאה בקבלת נתוני המתמחה: $e");
      return null;
    }
  }
}
