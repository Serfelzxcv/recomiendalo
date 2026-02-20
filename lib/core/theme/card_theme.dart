import 'package:flutter/material.dart';
import 'package:recomiendalo/core/theme/color_schemes.dart';

/// 🧩 Tema para tarjetas, contenedores, etc.
class AppCardTheme {
  static final light = CardThemeData(
    elevation: 0,
    color: AppColors.white,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.grayLight),
    ),
  );

  static final dark = CardThemeData(
    elevation: 0,
    color: AppColors.surfaceDark,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: AppColors.grayDark.withValues(alpha: 0.5)),
    ),
  );
}
