import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../repositories/auth_repository.dart';
import 'settings_screen.dart';

/// Екран заміни пароля користувача
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  
  final AuthRepository _authRepo = AuthRepository();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _onGoBack() {
    final route = ModalRoute.of(context);
    if (route != null && !route.isFirst) {
      Navigator.of(context).pop();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );
    }
  }

  void _onUpdatePassword() async {
    // Валідація полів через Form
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    final currentPass = _currentPassController.text.trim();
    final newPass = _newPassController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      // Виклик методу репозиторію (з повторною автентифікацією через поточний пароль)
      await _authRepo.updatePassword(
        currentPassword: currentPass,
        newPassword: newPass,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.surfaceInput,
            content: Text(
              'Password updated successfully!',
              style: TextStyle(color: AppColors.primary),
            ),
            duration: Duration(seconds: 2),
          ),
        );
        _onGoBack();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(e.toString().replaceAll('Exception: ', '')),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _onGoBack();
      },
      child: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.escape): _onGoBack,
          const SingleActivator(LogicalKeyboardKey.goBack): _onGoBack,
        },
        child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: _onGoBack,
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
                  'Your new password must be at least 6 characters long.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),

                // Форма зміни пароля з валідацією
                Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: Column(
                    children: [
                      // Поточний пароль
                      CustomTextField(
                        label: 'CURRENT PASSWORD',
                        hintText: 'Enter current password',
                        controller: _currentPassController,
                        prefixIcon: Icons.lock_outline_rounded,
                        isPassword: true,
                        validator: Validators.validateCurrentPassword,
                      ),
                      const SizedBox(height: 14),

                      // Новий пароль
                      CustomTextField(
                        label: 'NEW PASSWORD',
                        hintText: 'Enter new password',
                        controller: _newPassController,
                        prefixIcon: Icons.lock_reset_rounded,
                        isPassword: true,
                        validator: (val) => Validators.validateNewPassword(
                          val,
                          _currentPassController.text.trim(),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Підтвердження нового пароля
                      CustomTextField(
                        label: 'CONFIRM NEW PASSWORD',
                        hintText: 'Confirm new password',
                        controller: _confirmPassController,
                        prefixIcon: Icons.lock_rounded,
                        isPassword: true,
                        validator: (val) => Validators.validateConfirmPassword(
                          val,
                          _newPassController.text.trim(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Кнопка оновлення
                PrimaryButton(
                  text: 'Update Password',
                  icon: Icons.shield_outlined,
                  isLoading: _isLoading,
                  onPressed: _onUpdatePassword,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}
