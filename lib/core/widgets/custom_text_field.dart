import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Стилізоване поле введення із підтримкою валідації через Form/FormField
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
  final AutovalidateMode? autovalidateMode;

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
    this.autovalidateMode,
  }) : assert(prefixIcon != null || prefixWidget != null,
            'Either prefixIcon or prefixWidget must be provided');

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  late final TextEditingController _controller;
  bool _isInternalController = false;
  FormFieldState<String>? _fieldState;

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
    _controller.addListener(_handleControllerChanged);
  }

  void _handleControllerChanged() {
    if (_fieldState != null && _fieldState!.value != _controller.text) {
      _fieldState!.didChange(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    if (_isInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: _controller.text,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      builder: (FormFieldState<String> field) {
        _fieldState = field;
        final bool hasError = field.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceInput,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: hasError ? Colors.redAccent : AppColors.border,
                  width: hasError ? 1.5 : 1.0,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.prefixWidget ??
                      Icon(
                        widget.prefixIcon,
                        color: hasError ? Colors.redAccent : AppColors.textSecondary,
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
                            color: hasError ? Colors.redAccent : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        TextField(
                          controller: _controller,
                          obscureText: _obscureText,
                          keyboardType: widget.keyboardType,
                          onChanged: (val) {
                            field.didChange(val);
                            if (widget.onChanged != null) {
                              widget.onChanged!(val);
                            }
                          },
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
                        color: hasError ? Colors.redAccent : AppColors.textSecondary,
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
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(left: 14.0, top: 6.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.redAccent,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        field.errorText ?? '',
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
