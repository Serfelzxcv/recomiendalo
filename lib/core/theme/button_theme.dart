import 'package:flutter/material.dart';
import 'package:recomiendalo/core/theme/color_schemes.dart';

/// 🎯 Tema de botones (Filled y Outlined)
class AppButtonTheme {
  // Botón principal (relleno)
  static final filledLight = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      minimumSize: const Size.fromHeight(48),
    ),
  );

  // Botón principal (modo oscuro)
  static final filledDark = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      minimumSize: const Size.fromHeight(48),
    ),
  );

  // Botón secundario (contorno)
  static final outlinedLight = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: AppColors.black, width: 1.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      minimumSize: const Size.fromHeight(48),
      foregroundColor: AppColors.black,
      textStyle: const TextStyle(fontWeight: FontWeight.w500),
    ),
  );

  static final outlinedDark = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: AppColors.white, width: 1.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      minimumSize: const Size.fromHeight(48),
      foregroundColor: AppColors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.w500),
    ),
  );
}
