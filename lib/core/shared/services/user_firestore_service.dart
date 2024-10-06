import 'package:studiosync/core/services/firebase/firestore_service.dart';

class UserFirestoreService {
  final FirestoreService firestoreService;

  UserFirestoreService(this.firestoreService);

  Future<void> updateUserDocument(
      String collection, String docId, Map<String, dynamic> data) async {
    await firestoreService.updateDocument(collection, docId, data);
  }
}
