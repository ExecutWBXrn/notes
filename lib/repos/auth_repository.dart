import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository(this._firebaseAuth);

  Stream<User?> get authStateChages => _firebaseAuth.authStateChanges();

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print("Code: ${e.code}");
      if (e.code == 'weak-password') {
        throw "Занадто слабкий пароль";
      } else if (e.code == 'invalid-email') {
        throw "Не валідна електронна пошта";
      }
      throw "Виникла помилка при реєстрації, спробуйте знову!";
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception("Помилка при вході спробуйте знову!");
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception("Помилка розлогування!");
    }
  }
}
