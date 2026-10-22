import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/settings/change_password_screen.dart';
import 'screens/settings/edit_profile_screen.dart';
import 'screens/settings/settings_screen.dart';

void main() {
  runApp(const BikeDiaryApp());
}

class BikeDiaryApp extends StatelessWidget {
  const BikeDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bike Diary',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
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
