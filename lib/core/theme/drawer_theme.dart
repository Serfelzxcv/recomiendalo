import 'package:flutter/material.dart';
import 'package:recomiendalo/core/theme/color_schemes.dart';

/// 🧭 Tema visual del Drawer lateral
class AppDrawerTheme {
  static const light = DrawerThemeData(
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
    ),
  );

  static const dark = DrawerThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
    ),
  );
}
