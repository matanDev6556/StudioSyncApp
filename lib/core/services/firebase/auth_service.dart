import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Stream<String?> get userUidStream =>
      authStateChanges.map((user) => user?.uid);

  Future<bool> isTrainerAllowedToSignUp(String email) async {
    final QuerySnapshot allowedUsers = await _firestore
        .collection('allowedTrainers')
        .where('email', isEqualTo: email)
        .get();
    return allowedUsers.docs.isNotEmpty;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    return currentUser;
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password,
      {bool isTrainer = false}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = currentUser;

      if (user != null) {
        if (isTrainer) {
          // Additional logic for trainer
          // e.g. await _firestoreRepository.createUserDocument(...);
        }
        return user;
      }
    } catch (e) {
      debugPrint('Sign up error: ${e.toString()}');
      rethrow; // Re-throw the exception to propagate it to the calling function.
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();

  }
}
