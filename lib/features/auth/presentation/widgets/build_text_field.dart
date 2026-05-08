import 'package:flutter/material.dart';
import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:resq_app/core/constants/app_color.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const AppTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: AppColors.fieldText,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: context.fieldColor,
        hintStyle: TextStyle(
          color: context.textMutedColor,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          _iconForHint(hint),
          color: context.textMutedColor,
          size: 20,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  IconData _iconForHint(String value) {
    final hintValue = value.toLowerCase();

    if (hintValue.contains('password')) return Icons.lock_outline;
    if (hintValue.contains('phone')) return Icons.phone_outlined;
    if (hintValue.contains('email')) return Icons.email_outlined;
    if (hintValue.contains('id')) return Icons.badge_outlined;
    if (hintValue.contains('name')) return Icons.person_outline;

    return Icons.edit_outlined;
  }
}
