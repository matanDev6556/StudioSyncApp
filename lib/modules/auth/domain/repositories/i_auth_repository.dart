abstract class IAuthRepository<T> {
  T? get currentUser;
  Stream<T?> get authStateChanges;

  Future<bool> isTrainerAllowedToSignUp(String email);
  Future<T?> signInWithEmailAndPassword(String email, String password);
  Future<T?> signUpWithEmailAndPassword(String email, String password,
      {bool isTrainer = false});
  Future<void> signOut();
}
