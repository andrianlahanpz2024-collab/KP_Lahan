import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/social_button.dart';
import 'register_screen.dart';
import 'reset_password_screen.dart';
import '../home/home_screen.dart';

/// Екран авторизації (Sign In)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: 'alex.morgan@email.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'mypassword123');
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() {
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

              // Поля вводу
              CustomTextField(
                label: 'Email',
                controller: _emailController,
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                label: 'Password',
                controller: _passwordController,
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
              ),
              const SizedBox(height: 14),

              // Remember me та Forgot password?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _rememberMe = !_rememberMe;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _rememberMe
                              ? Icons.check
                              : Icons.check_box_outline_blank_rounded,
                          size: 16,
                          color: _rememberMe
                              ? AppColors.textSecondary
                              : AppColors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Remember me',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Кнопка Sign In
              PrimaryButton(
                text: 'Sign In',
                icon: Icons.arrow_forward_rounded,
                onPressed: _onSignIn,
              ),
              const SizedBox(height: 18),

              // Перехід до реєстрації
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                    children: [
                      TextSpan(
                        text: 'New to Bike Diary? ',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      TextSpan(
                        text: 'Create account',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 38),

              // 7. Розділювач "or continue with"
              const Row(
                children: [
                  Expanded(
                    child: Divider(color: AppColors.divider, thickness: 1),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text(
                      'or continue with',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: AppColors.divider, thickness: 1),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              //Кнопка Sign in with Google
              SocialButton(
                text: 'Sign in with Google',
                onPressed: _onSignIn,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
