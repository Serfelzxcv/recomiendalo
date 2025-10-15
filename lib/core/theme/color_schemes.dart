import 'package:flutter/material.dart';

/// 🎨 Paleta base de colores de la app
class AppColors {
  static const primary = Color(0xFF27C3AE); // Turquesa
  static const black = Colors.black;
  static const white = Colors.white;
}

/// 🎨 Esquemas de color completos (para ThemeData)
class AppColorSchemes {
  static const lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    secondary: AppColors.primary,
    onSecondary: AppColors.white,
    error: Colors.red,
    onError: AppColors.white,
    background: AppColors.white,
    onBackground: AppColors.black,
    surface: AppColors.white,
    onSurface: AppColors.black,
  );

  static const darkScheme = ColorScheme.dark(
    primary: AppColors.primary,
    onPrimary: AppColors.black,
    secondary: AppColors.primary,
    onSecondary: AppColors.black,
    background: AppColors.black,
    onBackground: AppColors.white,
    surface: Color(0xFF121212),
    onSurface: AppColors.white,
    error: Colors.red,
    onError: AppColors.white,
  );
}
