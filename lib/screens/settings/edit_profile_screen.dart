import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../repositories/auth_repository.dart';
import 'settings_screen.dart';

/// Екран керування профілем користувача 
class EditProfileScreen extends StatefulWidget {
  final String? currentName;
  final String? currentEmail;
  final void Function(String name, String email)? onProfileUpdated;

  const EditProfileScreen({
    super.key,
    this.currentName,
    this.currentEmail,
    this.onProfileUpdated,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthRepository _authRepo = AuthRepository();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _photoUrlController;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _isLoading = false;

  // Готові аватарки з HTTPS-посиланнями
  final List<String> _presetAvatars = [
    'https://t4.ftcdn.net/jpg/00/43/66/27/360_F_43662716_JTyPNZMFraD1nXR2O2AlDRFvwdyKaPpj.jpg',
    'https://www.shutterstock.com/image-vector/bicyclist-riding-their-bike-wearing-260nw-2425780237.jpg',
    'https://cdn-icons-png.flaticon.com/512/5623/5623792.png',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgG3kjJcW21W9gzQXdOcQnwDR0d42fBH_Bs4f4BpeqilN-1NggHz6ATVM&s=10',
  ];

  @override
  void initState() {
    super.initState();
    final user = _authRepo.currentUser;
    _nameController = TextEditingController(text: user?.displayName ?? 'Alex Morgan');
    _emailController = TextEditingController(text: user?.email ?? 'alex.morgan@email.com');
    _photoUrlController = TextEditingController(
      text: (user?.photoURL != null && user!.photoURL!.isNotEmpty)
          ? user.photoURL
          : _presetAvatars.first,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  void _onGoBack() {
    debugPrint('---> СИСТЕМНА КНОПКА НАЗАД СПРАЦЮВАЛА!');
    if (Navigator.canPop(context)) {
    Navigator.pop(context);
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }
  }

  void _handleSaveProfile() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authRepo.updateProfile(
        displayName: _nameController.text.trim(),
        photoUrl: _photoUrlController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile successfully updated!'),
            backgroundColor: Colors.green,
          ),
        );
        _onGoBack();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = _photoUrlController.text.trim();

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
              'Edit Profile',
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
                  // Аватар з попереднім переглядом фото
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            image: photoUrl.startsWith('http')
                                ? DecorationImage(
                                    image: NetworkImage(photoUrl),
                                    fit: BoxFit.cover,
                                    onError: (_, __) {},
                                  )
                                : null,
                          ),
                          child: !photoUrl.startsWith('http')
                              ? Center(
                                  child: Text(
                                    _getInitials(_nameController.text),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A281E),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Швидкий вибір готового аватара з HTTPS-посилань
                  const Text(
                    'Select Preset Avatar:',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _presetAvatars.map((url) {
                      final isSelected = _photoUrlController.text.trim() == url;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _photoUrlController.text = url;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.surfaceInput,
                            backgroundImage: NetworkImage(url),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  // Поля редагування профілю з валідацією
                  Form(
                    key: _formKey,
                    autovalidateMode: _autovalidateMode,
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'FULL NAME',
                          controller: _nameController,
                          prefixIcon: Icons.person_outline_rounded,
                          validator: Validators.validateName,
                          onChanged: (val) => setState(() {}),
                        ),
                        const SizedBox(height: 14),

                        CustomTextField(
                          label: 'EMAIL',
                          controller: _emailController,
                          prefixIcon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 14),

                        // Поле для власного HTTPS URL зображення з інтерактивним оновленням
                        CustomTextField(
                          label: 'AVATAR HTTPS URL',
                          controller: _photoUrlController,
                          prefixIcon: Icons.link_rounded,
                          validator: Validators.validateAvatarUrl,
                          onChanged: (val) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Кнопка збереження змін
                  _isLoading
                      ? const CircularProgressIndicator(color: AppColors.primary)
                      : PrimaryButton(
                          text: 'Save Changes',
                          icon: Icons.check_circle_outline_rounded,
                          onPressed: _handleSaveProfile,
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

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'AM';
  }
}
