import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Системні пакети Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

// Внутрішні модулі та репозиторії
import 'core/theme/app_theme.dart';
import 'repositories/auth_repository.dart';

// Екрани авторизації та налаштувань
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/settings/change_password_screen.dart';
import 'screens/settings/edit_profile_screen.dart';
import 'screens/settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ініціалізація Firebase
  await Firebase.initializeApp();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Відправка тестової події при запуску додатку
  await FirebaseAnalytics.instance.logEvent(
    name: 'lab_3_test_event',
    parameters: {
      'user_action': 'app_launch',
      'screen': 'login',
    },
  );
  runApp(const BikeDiaryApp());
}

class BikeDiaryApp extends StatelessWidget {
  const BikeDiaryApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bike Diary',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/change-password': (context) => const ChangePasswordScreen(),
      },
    );
  }
}

class TestCrashScreen extends StatelessWidget {
  const TestCrashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crashlytics Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Виклик примусової тестової помилки Crashlytics
                FirebaseCrashlytics.instance.crash();
              },
              child: const Text('Generate Crash'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Відновлення сеансу користувача (Вимога 4)
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AuthRepository();
    final user = repo.currentUser;
    if (user != null) {
      return const HomeScreen(); // Користувач уже увійшов (сеанс відновлено)
    }
    return StreamBuilder<User?>(
      stream: repo.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen(); // Вхід підтверджено стрімом
        }
        return const LoginScreen(); // Неавторизований користувач
      },
    );
  }
}
