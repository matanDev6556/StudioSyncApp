import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  // can use for add/update
  Future<void> setDocument(String collectionPath, String documentId,
      Map<String, dynamic> data) async {
    await _firestore.collection(collectionPath).doc(documentId).set(data);
  }

  // פונקציה למחיקת מסמך
  Future<void> deleteDocument(String collectionPath, String documentId) async {
    await _firestore.collection(collectionPath).doc(documentId).delete();
  }

  Future<void> deleteDocumentAndSubcollections(String collectionPath,
      String docId, List<String> subcollectionNames) async {
    final documentRef = firestore.collection(collectionPath).doc(docId);

    for (String subcollectionName in subcollectionNames) {
      final subcollectionRef = documentRef.collection(subcollectionName);

      final subcollectionDocs = await subcollectionRef.get();
      for (var doc in subcollectionDocs.docs) {
        await doc.reference.delete();
      }
    }

    // Finally, delete the main document
    await documentRef.delete();
  }

  Future<void> deleteDocumentsWithFilters(
      String collectionPath, Map<String, dynamic> filters) async {
    try {
    
      Query query = _firestore.collection(collectionPath);

      
      filters.forEach((field, value) {
        query = query.where(field, isEqualTo: value);
      });

    
      QuerySnapshot querySnapshot = await query.get();

     
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print("Documents matching the filters were deleted successfully.");
    } catch (e) {
      print("Error deleting documents: $e");
    }
  }

  // פונקציה לקבלת מסמך לפי מזהה
  Future<Map<String, dynamic>?> getDocument(
    String collectionPath,
    String documentId,
  ) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection(collectionPath).doc(documentId).get();
      return documentSnapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  // פונקציה לקבלת כל המסמכים מקולקציה
  Future<List<Map<String, dynamic>>> getCollection(
      String collectionPath) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection(collectionPath).get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  // פונקציה לקבלת מסמכים עם תנאים (פילטרים)
  Future<List<Map<String, dynamic>>> getCollectionWithFilters(
      String collectionPath, Map<String, dynamic> filters) async {
    Query query = _firestore.collection(collectionPath);

    filters.forEach((field, value) {
      query = query.where(field, isEqualTo: value);
    });

    QuerySnapshot querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  // stream doc
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument(String path) {
    return _firestore.doc(path).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection(String path) {
    return FirebaseFirestore.instance.collection(path).snapshots();
  }

  Future<int> countDocumentsInCollection(String collectionPath) async {
    try {
      // שליפת כל המסמכים מתוך הנתיב שניתן
      final querySnapshot = await firestore.collection(collectionPath).get();

      // חישוב כמות המסמכים שנמצאו
      return querySnapshot.size;
    } catch (e) {
      print("Error counting documents: $e");
      return 0;
    }
  }
}
