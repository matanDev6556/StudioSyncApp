import 'package:flutter/foundation.dart';
import 'package:studiosync/core/domain/repositories/i_widget_tree_repository.dart';

class CheckUserRoleUseCase {
  final IWidgetTreeRepository _iWidgetTreeRepository;

  CheckUserRoleUseCase({required IWidgetTreeRepository iWidgetTreeRepository})
      : _iWidgetTreeRepository = iWidgetTreeRepository;

  Future<String?> call(String uid) async {
    
    try {
      return await _iWidgetTreeRepository.checkUserRole(uid);
    } catch (e) {
      debugPrint("שגיאה בבדיקת התפקיד: $e");
      return null;
    }
  }
}
