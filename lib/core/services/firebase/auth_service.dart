import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

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
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = currentUser;
    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
