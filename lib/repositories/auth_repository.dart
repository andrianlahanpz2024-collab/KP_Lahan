import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Репозиторій автентифікації та керування профілем Firebase Auth
class AuthRepository {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Стрім стану авторизації (для відновлення сеансу)
  Stream<User?> get authStateChanges {
    try {
      if (Firebase.apps.isNotEmpty) {
        return _auth.authStateChanges();
      }
    } catch (_) {}
    return Stream.value(null);
  }

  // Поточний користувач
  User? get currentUser {
    try {
      if (Firebase.apps.isNotEmpty) {
        return _auth.currentUser;
      }
    } catch (_) {}
    return null;
  }

  // Реєстрація через Email та Пароль
  Future<UserCredential> signUp({
    required String email,
    required String password,
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
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Вхід за Email / Password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Вхід через Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // Скасовано користувачем

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to log in via Google: $e');
    }
  }

  // Відновлення пароля через Email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Зміна пароля (із повторною автентифікацією поточним паролем)
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = currentUser;
      if (user == null || user.email == null) {
        throw Exception('User is not authenticated');
      }

      // Повторна автентифікація перед зміною пароля
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Оновлення пароля
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw Exception('Incorrect current password.');
      }
      if (e.code == 'requires-recent-login') {
        throw Exception('This security operation requires a recent login. Please sign out and sign in again.');
      }
      if (e.code == 'weak-password') {
        throw Exception('The new password is too weak (minimum 6 characters).');
      }
      throw Exception(_handleAuthException(e));
    }
  }

  // Оновлення фото профілю (HTTPS URL) та імені
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final user = currentUser;
      if (user != null) {
        if (displayName != null) await user.updateDisplayName(displayName.trim());
        if (photoUrl != null) await user.updatePhotoURL(photoUrl.trim());
        await user.reload();
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Вихід із системи
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    try {
      await _auth.signOut();
    } catch (_) {}
  }

  // Переклад помилок Firebase для користувача
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'User with this email not found.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect password or email.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'The new password is too weak (minimum 6 characters).';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'requires-recent-login':
        return 'This security operation requires a recent login. Please sign out and sign in again.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      default:
        return e.message ?? 'An unknown error occurred during authentication.';
    }
  }
}
