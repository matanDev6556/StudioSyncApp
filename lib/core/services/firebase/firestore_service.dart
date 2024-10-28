import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  // פונקציה ליצירת מסמך חדש
  Future<void> createDocument(String collectionPath, String documentId,
      Map<String, dynamic> data) async {
    await _firestore.collection(collectionPath).doc(documentId).set(data);
  }

  // פונקציה לעדכון מסמך קיים
  Future<void> updateDocument(String collectionPath, String documentId,
      Map<String, dynamic> data) async {
    await _firestore.collection(collectionPath).doc(documentId).update(data);
  }

  // פונקציה למחיקת מסמך
  Future<void> deleteDocument(String collectionPath, String documentId) async {
    await _firestore.collection(collectionPath).doc(documentId).delete();
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

  Future<Map<String, dynamic>?> getNestedDocument(
    String parentCollectionPath,
    String parentDocumentId,
    String childCollectionPath,
    String childDocumentId,
  ) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection(parentCollectionPath)
          .doc(parentDocumentId)
          .collection(childCollectionPath)
          .doc(childDocumentId)
          .get();

      return documentSnapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Error fetching nested document: $e");
      return null;
    }
  }

  Future<void> addNastedDocument(
    String parentCollectionPath,
    String parentDocumentId,
    String childCollectionPath,
    String childDocumentId,
    Map<String, dynamic> mapData,
  ) async {
    try {
      // הוספה של מסמך מתאמן לתוך הקולקציה של המאמן
      await _firestore
          .collection(parentCollectionPath)
          .doc(parentDocumentId)
          .collection(childCollectionPath)
          .doc(childDocumentId)
          .set(mapData);

      print("Added nasted doc");
    } catch (e) {
      print("Failed to add trainee: $e");
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
}
