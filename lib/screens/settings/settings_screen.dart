import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_colors.dart';
import '../../repositories/auth_repository.dart';
import '../auth/login_screen.dart';
import '../home/home_screen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';

/// Екран налаштувань (Settings Screen)
/// Керування профілем користувача та заміна пароля
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthRepository _authRepo = AuthRepository();

  // Дані користувача (якщо авторизований — підтягуються з Firebase, інакше за замовчуванням)
  String _userName = 'Alex Morgan';
  String _userEmail = 'alex.morgan@email.com';
  String? _userPhotoUrl;

  bool _maintenanceReminders = true;
  bool _emailNotifications = false;

  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    try {
      _authSubscription = _authRepo.authStateChanges.listen((user) {
        if (mounted) {
          _loadUserData();
        }
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void _loadUserData() {
    try {
      final user = _authRepo.currentUser;
      if (user != null) {
        setState(() {
          _userEmail = user.email ?? _userEmail;
          if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
            _userName = user.displayName!;
          } else if (user.email != null && user.email!.contains('@')) {
            _userName = user.email!.split('@').first;
          }
          _userPhotoUrl = user.photoURL;
        });
      }
    } catch (_) {}
  }

  void _onProfileUpdated(String name, String email) {
    setState(() {
      _userName = name;
      _userEmail = email;
    });
  }

  void _openEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );
    _loadUserData();
  }

  void _onGoBack() {
    final route = ModalRoute.of(context);
    if (route != null && !route.isFirst) {
      Navigator.of(context).pop();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].length >= 2 ? parts[0].substring(0, 2).toUpperCase() : parts[0].toUpperCase();
    }
    return 'AM';
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
        bottomNavigationBar: _buildBottomNav(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Верхній рядок: кнопка "Назад" та заголовок "Settings"
                Row(
                  children: [
                    GestureDetector(
                      onTap: _onGoBack,
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
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Settings',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Bike Diary preferences',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 2. Картка профілю користувача
                GestureDetector(
                  onTap: _openEditProfile,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF142017),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF243628),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Аватар з ініціалами або фото
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _userPhotoUrl != null && _userPhotoUrl!.isNotEmpty
                              ? Image.network(
                                  _userPhotoUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Center(
                                    child: Text(
                                      _getInitials(_userName),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    _getInitials(_userName),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                _userEmail,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Бейдж LEVEL 12
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B3822),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF285433),
                              width: 0.8,
                            ),
                          ),
                          child: const Text(
                            'LEVEL 12',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Секція Account
                _buildSectionHeader('Account'),
                _buildCardContainer([
                  _buildActionTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Edit Profile',
                    onTap: _openEditProfile,
                  ),
                  _buildDivider(),
                  _buildActionTile(
                    icon: Icons.vpn_key_outlined,
                    title: 'Change Password',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                ]),
                const SizedBox(height: 20),

                // 4. Секція Tracking & Units
                _buildSectionHeader('Tracking & Units'),
                _buildCardContainer([
                  _buildValueTile(
                    icon: Icons.straighten_rounded,
                    title: 'Measurement units',
                    value: 'Metric • km, km/h',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildValueTile(
                    icon: Icons.filter_center_focus_rounded,
                    title: 'GPS precision',
                    value: 'High accuracy',
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: 20),

                // 5. Секція Notifications
                _buildSectionHeader('Notifications'),
                _buildCardContainer([
                  _buildSwitchTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Maintenance reminders',
                    value: _maintenanceReminders,
                    onChanged: (val) {
                      setState(() {
                        _maintenanceReminders = val;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    icon: Icons.mail_outline_rounded,
                    title: 'Email notifications',
                    value: _emailNotifications,
                    onChanged: (val) {
                      setState(() {
                        _emailNotifications = val;
                      });
                    },
                  ),
                ]),
                const SizedBox(height: 20),

                // 6. Секція Language
                _buildSectionHeader('Language'),
                _buildCardContainer([
                  _buildActionTile(
                    icon: Icons.translate_rounded,
                    title: 'English',
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: 20),

                // 7. Секція App info
                _buildSectionHeader('App info'),
                _buildCardContainer([
                  _buildValueTile(
                    icon: Icons.info_outline_rounded,
                    title: 'Bike Diary',
                    value: 'v2.8.1',
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: 24),

                // 8. Кнопка Log Out
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await _authRepo.signOut();
                      } catch (_) {}
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF381816),
                      foregroundColor: const Color(0xFFFF5252),
                      elevation: 0,
                      side: const BorderSide(
                        color: Color(0xFF522220),
                        width: 1.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: Color(0xFFFF5252),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Log Out',
                          style: TextStyle(
                            color: Color(0xFFFF5252),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCardContainer(List<Widget> children) {
    return Material(
      color: const Color(0xFF142017),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF243628),
            width: 1.0,
          ),
        ),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFF1D2E21),
      indent: 58,
    );
  }

  Widget _buildLeadingIcon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF1A281E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      leading: _buildLeadingIcon(icon),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textSecondary,
        size: 20,
      ),
    );
  }

  Widget _buildValueTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      leading: _buildLeadingIcon(icon),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      leading: _buildLeadingIcon(icon),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
        activeTrackColor: const Color(0xFF2A5935),
        inactiveThumbColor: const Color(0xFF8E9590),
        inactiveTrackColor: const Color(0xFF28362B),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF101712),
        border: Border(
          top: BorderSide(
            color: Color(0xFF1E2E22),
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.directions_bike_rounded, 'Garage'),
          _buildNavItem(1, Icons.location_on_rounded, 'Map'),
          _buildNavItem(2, Icons.menu_book_rounded, 'Diary'),
          _buildNavItem(3, Icons.settings_rounded, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    // Вкладка Settings активна
    final isSelected = index == 3;

    return GestureDetector(
      onTap: () {
        if (index != 3) {
          // Перехід назад до мапи або іншої вкладки
          _onGoBack();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1C3623),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 22,
              ),
            )
          else
            Icon(
              icon,
              color: AppColors.textSecondary,
              size: 22,
            ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
