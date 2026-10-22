import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Стилізоване поле введення відповідно
class CustomTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final bool isPassword;
  final bool upperCaseLabel;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.initialValue,
    this.controller,
    this.prefixIcon,
    this.prefixWidget,
    this.isPassword = false,
    this.upperCaseLabel = true,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
  }) : assert(prefixIcon != null || prefixWidget != null,
            'Потрібно вказати prefixIcon або prefixWidget');

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  late final TextEditingController _controller;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: widget.initialValue ?? '');
      _isInternalController = true;
    }
  }

  @override
  void dispose() {
    if (_isInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceInput,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.prefixWidget ??
              Icon(
                widget.prefixIcon,
                color: AppColors.textSecondary,
                size: 22,
              ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.upperCaseLabel
                      ? widget.label.toUpperCase()
                      : widget.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: widget.upperCaseLabel ? 1.1 : 0.2,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                TextFormField(
                  controller: _controller,
                  obscureText: _obscureText,
                  keyboardType: widget.keyboardType,
                  validator: widget.validator,
                  onChanged: widget.onChanged,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.isPassword)
            IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textSecondary,
                size: 22,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 20,
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
        ],
      ),
    );
  }
}
