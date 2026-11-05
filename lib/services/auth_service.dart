import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Поточний користувач
  User? get currentUser => _auth.currentUser;

  // Стрім стану авторизації
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 1. Реєстрація через Email та Пароль
  Future<UserCredential?> signUpWithEmail(
    String email,
    String password, {
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (displayName != null && displayName.trim().isNotEmpty) {
        await credential.user?.updateDisplayName(displayName.trim());
        await credential.user?.reload();
      }
      return credential;
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    }
  }

  // 2. Вхід через Email та Пароль
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Sign-in error: $e');
      rethrow;
    }
  }

  // 3. Вхід через Google Account
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // Користувач скасував вхід

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Google Sign-In error: $e');
      rethrow;
    }
  }

  // 4. Оновлення імені або фото
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        if (displayName != null) await user.updateDisplayName(displayName.trim());
        if (photoUrl != null) await user.updatePhotoURL(photoUrl);
        await user.reload();
      }
    } catch (e) {
      print('Profile update error: $e');
      rethrow;
    }
  }

  // Вихід із системи
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    await _auth.signOut();
  }
}
