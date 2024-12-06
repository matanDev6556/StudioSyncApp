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

  // stream doc  
   Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument(String path) {
    return _firestore.doc(path).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection(String path) {
  return FirebaseFirestore.instance.collection(path).snapshots();
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

  Future<void> deleteDocumentsWithFilters(
    String collectionPath, Map<String, dynamic> filters) async {
  try {
    // יצירת השאילתה
    Query query = _firestore.collection(collectionPath);

    // הוספת תנאים לשאילתה עבור כל פילטר
    filters.forEach((field, value) {
      query = query.where(field, isEqualTo: value);
    });

    // שליפת המסמכים התואמים
    QuerySnapshot querySnapshot = await query.get();

    // מעבר על המסמכים ומחיקת כל אחד מהם
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    print("Documents matching the filters were deleted successfully.");
  } catch (e) {
    print("Error deleting documents: $e");
  }
}
}
