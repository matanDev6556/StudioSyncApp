import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studiosync/core/services/iauth_service.dart';

class FirebaseAuthService implements IAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  User? get currentUser => _auth.currentUser;
  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  @override
  Stream<String?> get userUidStream =>
      authStateChanges.map((user) => user?.uid);

  @override
  Future<bool> isTrainerAllowedToSignUp(String email) async {
    final QuerySnapshot allowedUsers = await _firestore
        .collection('allowedTrainers')
        .where('email', isEqualTo: email)
        .get();
    return allowedUsers.docs.isNotEmpty;
  }

  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    return currentUser;
  }

  @override
  Future<User?> signUpWithEmailAndPassword(String email, String password,
      {bool isTrainer = false}) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = currentUser;
    return user;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
