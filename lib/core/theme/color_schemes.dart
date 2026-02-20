import 'package:flutter/material.dart';

/// 🎨 Paleta base de colores de la app
class AppColors {
  static const primary = Color(0xFF27C3AE); // Turquesa
  static const grayLight = Color(0xFFE2E8F0);
  static const grayDark = Color(0xFF475569);
  static const black = Colors.black;
  static const white = Colors.white;
  static const surfaceLight = Color(0xFFF8FAFC);
  static const surfaceDark = Color(0xFF111827);
}

/// 🎨 Esquemas de color completos (para ThemeData)
class AppColorSchemes {
  static final lightScheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.primary,
        onSecondary: AppColors.white,
        surface: AppColors.white,
      );

  static final darkScheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ).copyWith(
        primary: AppColors.primary,
        onPrimary: AppColors.black,
        secondary: AppColors.primary,
        onSecondary: AppColors.black,
        surface: AppColors.surfaceDark,
      );
}
