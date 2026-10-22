import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primary_button.dart';

/// Екран заміни пароля користувача (Вимога 3.2)
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPassController =
      TextEditingController(text: 'oldPassword123');
  final TextEditingController _newPassController =
      TextEditingController(text: 'newSuperPass2026!');
  final TextEditingController _confirmPassController =
      TextEditingController(text: 'newSuperPass2026!');

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _onUpdatePassword() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.surfaceInput,
        content: Text(
          'Password updated successfully! (Demo)',
          style: TextStyle(color: AppColors.primary),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.surfaceInput,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Іконка ключа
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
                    Icons.vpn_key_rounded,
                    color: Colors.black,
                    size: 38,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Create New Password',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your new password must be at least 8 characters long and contain numbers and symbols.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // Поточний пароль
              CustomTextField(
                label: 'CURRENT PASSWORD',
                controller: _currentPassController,
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
              ),
              const SizedBox(height: 14),

              // Новий пароль
              CustomTextField(
                label: 'NEW PASSWORD',
                controller: _newPassController,
                prefixIcon: Icons.lock_reset_rounded,
                isPassword: true,
              ),
              const SizedBox(height: 14),

              // Підтвердження нового пароля
              CustomTextField(
                label: 'CONFIRM NEW PASSWORD',
                controller: _confirmPassController,
                prefixIcon: Icons.lock_rounded,
                isPassword: true,
              ),
              const SizedBox(height: 28),

              // Кнопка оновлення
              PrimaryButton(
                text: 'Update Password',
                icon: Icons.shield_outlined,
                onPressed: _onUpdatePassword,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
