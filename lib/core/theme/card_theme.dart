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
      side: BorderSide(color: Colors.grey[200]!),
    ),
  );

  static final dark = CardThemeData(
    elevation: 0,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: Colors.white.withOpacity(0.1)),
    ),
  );
}
