import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../home/home_screen.dart';

/// Екран реєстрації (Create account)
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Alex Morgan');
  final TextEditingController _emailController =
      TextEditingController(text: 'alex.morgan@email.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'mypassword123');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onCreateAccount() {
    // перехід на домашній екран
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // Логотип
              const AppLogo(size: 78, iconSize: 44),
              const SizedBox(height: 24),

              // Заголовок і підзаголовок
              const Text(
                'Bike Diary',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Track every ride. Remember every road.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 38),

              // 3. Поле "ACCOUNT NAME" з іконкою користувача з олівцем
              CustomTextField(
                label: 'ACCOUNT NAME',
                controller: _nameController,
                prefixWidget: SizedBox(
                  width: 24,
                  height: 24,
                  child: Stack(
                    children: const [
                      Positioned(
                        left: 0,
                        top: 1,
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Icon(
                          Icons.edit,
                          color: AppColors.textSecondary,
                          size: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Поле "EMAIL"
              CustomTextField(
                label: 'EMAIL',
                controller: _emailController,
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),

              // Поле "PASSWORD"
              CustomTextField(
                label: 'PASSWORD',
                controller: _passwordController,
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
              ),
              const SizedBox(height: 24),

              // Кнопка "Create account"
              PrimaryButton(
                text: 'Create account',
                icon: Icons.arrow_forward_rounded,
                onPressed: _onCreateAccount,
              ),
              const SizedBox(height: 28),

              // Навігація назад до авторизації (для зручності під час тестування)
              GestureDetector(
                onTap: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacementNamed(context, '/');
                  }
                },
                child: const Text(
                  'Already have an account? Sign In',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
