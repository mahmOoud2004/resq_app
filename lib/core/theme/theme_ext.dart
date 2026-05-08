import 'package:flutter/material.dart';
import 'package:resq_app/core/constants/app_color.dart';

extension ThemeExt on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get backgroundColor => isDarkMode ? AppColors.background : const Color(0xffF8FAFC);
  Color get backgroundColorDeep => isDarkMode ? AppColors.backgroundDeep : const Color(0xffF1F5F9);
  Color get surfaceColor => isDarkMode ? AppColors.surface : Colors.white;
  Color get surfaceLightColor => isDarkMode ? AppColors.surfaceLight : const Color(0xffF1F5F9);
  Color get textColor => isDarkMode ? Colors.white : const Color(0xff1E293B);
  Color get textSecondaryColor => isDarkMode ? AppColors.textSecondary : const Color(0xff64748B);
  Color get textMutedColor => isDarkMode ? AppColors.textMuted : const Color(0xff94A3B8);
  Color get borderColor => isDarkMode ? AppColors.border : const Color(0xffE2E8F0);
  Color get fieldColor => isDarkMode ? AppColors.fieldColor : Colors.white;
}
