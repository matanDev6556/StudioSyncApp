import 'package:studiosync/core/data/data_source/firebase/firestore_service.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/core/domain/repositories/i_widget_tree_repository.dart';



class WidgetTreeFirebaseRepository implements IWidgetTreeRepository {
  final FirestoreService _firestoreService;

  WidgetTreeFirebaseRepository({
    required FirestoreService firestoreService,
    required IAuthRepository iAuthRepository,
  }) : _firestoreService = firestoreService;

  @override
  Future<String?> checkUserRole(String uid) async {
    final trainerData = await _firestoreService.getDocument('trainers', uid);
    if (trainerData != null) return UserRole.trainer.value;

    final traineeData = await _firestoreService.getDocument('AllTrainees', uid);
    if (traineeData != null) return UserRole.trainee.value;

    return null;
  }
}

enum UserRole {
  trainer('trainer'),
  trainee('trainee');

  const UserRole(this.value);
  final String value;
}