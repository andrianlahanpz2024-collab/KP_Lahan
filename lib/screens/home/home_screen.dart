import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../settings/settings_screen.dart';

/// Головний екран (Home / Map Screen)
class HomeScreen extends StatelessWidget {
  // Hardcoded-дані користувача
  static const String _activeBike = 'Trek Marlin 7';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF142017),
      bottomNavigationBar: _buildBottomNav(context),
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Шар векторної темної мапи на чистому Flutter
            const Positioned.fill(
              child: CustomPaint(
                painter: _MapBackgroundPainter(),
              ),
            ),

            // Шар маркерів на мапі (закріплені на координатах доріг)
            LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;

                return Stack(
                  children: [
                    // Маркер: Майстерня (помаранчевий з ключем)
                    Positioned(
                      top: h * 0.23,
                      right: w * 0.22,
                      child: _buildMapMarker(
                        icon: Icons.build_rounded,
                        bgColor: const Color(0xFFFFA94D),
                        iconColor: Colors.black,
                      ),
                    ),

                    // Маркер: Водна станція (блакитний з краплею)
                    Positioned(
                      top: h * 0.30,
                      left: w * 0.26,
                      child: _buildMapMarker(
                        icon: Icons.water_drop_rounded,
                        bgColor: const Color(0xFF5AC8FA),
                        iconColor: Colors.black,
                      ),
                    ),

                    // Маркер: Поточна позиція користувача (біле кільце + зелена точка)
                    Positioned(
                      top: h * 0.305,
                      left: w * 0.48,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.6),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Основний шар інтерфейсу користувача
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //ВЕРХНІЙ РЯД: Ready to ride + круглі кнопки праворуч
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildReadyToRideChip(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCircularControl(
                              icon: Icons.filter_center_focus_rounded,
                            ),
                            const SizedBox(height: 10),
                            _buildCircularControl(
                              icon: Icons.layers_rounded,
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Відштовхує елементи вниз
                    const Spacer(),

                    // СЕРЕДНІЙ РЯД: Плашки відстаней ліворуч та Add Marker праворуч
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildDistanceChip(
                                icon: Icons.water_drop_outlined,
                                iconColor: const Color(0xFF5AC8FA),
                                title: 'Water station • 0.8 km',
                              ),
                              const SizedBox(height: 6),
                              _buildDistanceChip(
                                icon: Icons.build_rounded,
                                iconColor: const Color(0xFFFFA94D),
                                title: 'Repair shop • 1.2 km',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildAddMarkerButton(),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // КАРТКА ACTIVE BIKE
                    _buildActiveBikeCard(),

                    const SizedBox(height: 12),

                    // ГОЛОВНА КНОПКА START TRACKING
                    _buildStartTrackingButton(),

                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadyToRideChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF142017),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF26382A),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.rotate(
            angle: -math.pi / 4,
            child: const Icon(
              Icons.navigation_rounded,
              color: AppColors.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Ready to ride',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularControl({
    required IconData icon,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF142017),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF26382A),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildDistanceChip({
    required IconData icon,
    required Color iconColor,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF142017),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF26382A),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 13),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMarkerButton() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF142017),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF26382A),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add_location_alt_outlined,
            color: AppColors.primary,
            size: 16,
          ),
          SizedBox(width: 5),
          Text(
            'Add Marker',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveBikeCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF142017),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF26382A),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Мініатюра велосипеда
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF0F1712),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF243628),
                width: 1.0,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.directions_bike_rounded,
                color: Color(0xFF5AC8FA),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ACTIVE BIKE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                _activeBike,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildStartTrackingButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_circle_outline_rounded,
              color: Colors.black,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Start Tracking',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapMarker({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: iconColor,
          size: 17,
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
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
          _buildNavItem(context, 0, Icons.directions_bike_rounded, 'Garage'),
          _buildNavItem(context, 1, Icons.location_on_rounded, 'Map'),
          _buildNavItem(context, 2, Icons.menu_book_rounded, 'Diary'),
          _buildNavItem(context, 3, Icons.settings_rounded, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    // Тільки Map підсвічена як активна
    final isSelected = index == 1;

    return GestureDetector(
      onTap: () {
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
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

/// Малювальник векторної стилізованої мапи у темних тонах
class _MapBackgroundPainter extends CustomPainter {
  const _MapBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Фонове заповнення
    final bgPaint = Paint()..color = const Color(0xFF142017);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // Міські квартали / парки (заокруглені полігони)
    final blockPaint1 = Paint()..color = const Color(0xFF1D2E23);
    final blockPaint2 = Paint()..color = const Color(0xFF18261C);

    // Верхній лівий квартал
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12, h * 0.08, w * 0.28, h * 0.14),
        const Radius.circular(24),
      ),
      blockPaint1,
    );

    // Верхній правий квартал
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.55, h * 0.07, w * 0.36, h * 0.13),
        const Radius.circular(24),
      ),
      blockPaint2,
    );

    // Середній лівий квартал
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12, h * 0.34, w * 0.30, h * 0.14),
        const Radius.circular(24),
      ),
      blockPaint2,
    );

    // Середній правий квартал
    canvas.save();
    canvas.translate(w * 0.72, h * 0.38);
    canvas.rotate(0.12);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: w * 0.34,
          height: h * 0.18,
        ),
        const Radius.circular(28),
      ),
      blockPaint1,
    );
    canvas.restore();

    // Сітка доріг
    final roadPaint = Paint()
      ..color = const Color(0xFF2C3E31)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Головна діагональна дорога зліва направо
    roadPaint.strokeWidth = 20;
    final path1 = Path()
      ..moveTo(-20, h * 0.24)
      ..lineTo(w * 0.44, h * 0.19)
      ..lineTo(w + 20, h * 0.14);
    canvas.drawPath(path1, roadPaint);

    // Вертикальна дорога
    roadPaint.strokeWidth = 24;
    final path2 = Path()
      ..moveTo(w * 0.48, -20)
      ..lineTo(w * 0.40, h * 0.35)
      ..lineTo(w * 0.32, h + 20);
    canvas.drawPath(path2, roadPaint);

    // З'єднувальна дорога через центр
    roadPaint.strokeWidth = 14;
    final path3 = Path()
      ..moveTo(w * 0.36, h * 0.42)
      ..lineTo(w * 0.75, h * 0.54);
    canvas.drawPath(path3, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
