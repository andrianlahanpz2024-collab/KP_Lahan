import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Віджет логотипу застосунку: неонова заокруглена плашка з іконкою велосипеда
class AppLogo extends StatelessWidget {
  final double size;
  final double iconSize;

  const AppLogo({
    super.key,
    this.size = 76.0,
    this.iconSize = 44.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2E5CF362),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.directions_bike_rounded,
          color: Colors.black,
          size: iconSize,
        ),
      ),
    );
  }
}
