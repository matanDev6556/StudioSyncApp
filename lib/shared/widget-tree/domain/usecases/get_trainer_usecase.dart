import 'package:flutter/foundation.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';
import 'package:studiosync/shared/widget-tree/domain/repositories/i_widget_tree_repository.dart';

class GetTrainerDataUseCase {
  final IWidgetTreeRepository _iWidgetTreeRepository;

  GetTrainerDataUseCase({required IWidgetTreeRepository iWidgetTreeRepository})
      : _iWidgetTreeRepository = iWidgetTreeRepository;

  Future<TrainerModel?> call(String uid) async {
    try {
      return await _iWidgetTreeRepository.getTrainerData(uid);
    } catch (e) {
      debugPrint("שגיאה בקבלת נתוני המדריך: $e");
      return null;
    }
  }
}
