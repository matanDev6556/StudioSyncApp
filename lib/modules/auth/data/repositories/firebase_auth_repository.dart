import 'package:firebase_auth/firebase_auth.dart';
import 'package:studiosync/core/services/firebase/auth_service.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';

class FirebaseAuthRepository implements IAuthRepository<User> {
  final FirebaseAuthService _firebaseAuthService;

  FirebaseAuthRepository({required FirebaseAuthService firebaseAuthService})
      : _firebaseAuthService = firebaseAuthService;

  @override
  get currentUser => _firebaseAuthService.currentUser;

  @override
  Future<bool> isTrainerAllowedToSignUp(String email) {
    return _firebaseAuthService.isTrainerAllowedToSignUp(email);
  }

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) {
    return _firebaseAuthService.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuthService.signOut();
  }

  @override
  Future<User?> signUpWithEmailAndPassword(String email, String password,
      {bool isTrainer = false}) async {
    return _firebaseAuthService.signUpWithEmailAndPassword(email, password,
        isTrainer: isTrainer);
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuthService.authStateChanges;
}
