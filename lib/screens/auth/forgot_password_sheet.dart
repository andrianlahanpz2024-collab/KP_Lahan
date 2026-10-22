import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primary_button.dart';

/// Модальне вікно відновлення пароля через Email
class ForgotPasswordSheet extends StatelessWidget {
  const ForgotPasswordSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => const ForgotPasswordSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: bottomInset + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Індикатор перетягування
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          // Іконка замка
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0x1F5CF362),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Reset Password',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter the email associated with your account and we will send a password reset link.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          const CustomTextField(
            label: 'Email Address',
            hintText: 'alex.morgan@email.com',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Send Reset Link',
            icon: Icons.send_rounded,
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.surfaceInput,
                  content: Text(
                    'Reset link sent to your email! (Mock)',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  duration: Duration(seconds: 3),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
