import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Кнопка авторизації через сторонні сервіси (Google) без зовнішніх бібліотек
class SocialButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const SocialButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.buttonDark,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Кругла іконка Google
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'G',
                  style: TextStyle(
                    color: Color(0xFF4285F4),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'sans-serif',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
