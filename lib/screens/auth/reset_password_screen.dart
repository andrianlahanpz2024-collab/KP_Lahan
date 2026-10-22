import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primary_button.dart';
import 'login_screen.dart';

/// Екран відновлення пароля (Reset Password) у точній відповідності до дизайну
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: 'alex.morgan@email.com');
  bool _isSuccessVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendResetLink() {
    setState(() {
      _isSuccessVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Верхня панель: кругла кнопка "Назад" та заголовок "Reset Password"
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceInput,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.textPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Reset Password',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 42),

              // 2. Зелена плашка з іконкою листа
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x2E5CF362),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.mail_outline_rounded,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // 3. Заголовок "Forgot your password?"
              const Text(
                'Forgot your password?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),

              // 4. Опис
              const Text(
                'Enter your registered email address and we will\nsend you a link to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.45,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 38),

              // 5. Поле вводу Email
              CustomTextField(
                label: 'Email address',
                controller: _emailController,
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // 6. Кнопка "Send Reset Link"
              PrimaryButton(
                text: 'Send Reset Link',
                onPressed: _onSendResetLink,
              ),
              const SizedBox(height: 20),

              // 7. Повідомлення про успішне відправлення (з'являється після натискання Send Reset Link)
              if (_isSuccessVisible)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF132017),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF1F3D28),
                      width: 1.0,
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFFBAC5BC),
                              height: 1.35,
                            ),
                            children: [
                              TextSpan(
                                text: 'Check your inbox! ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'We\'ve sent password\nreset instructions to your email.',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: _isSuccessVisible ? 40 : 80),

              // 8. Посилання "Back to Sign In" внизу екрана
              GestureDetector(
                onTap: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Back to Sign In',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
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
