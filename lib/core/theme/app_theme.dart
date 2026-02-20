import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recomiendalo/core/theme/color_schemes.dart';
import 'package:recomiendalo/core/theme/button_theme.dart';
import 'package:recomiendalo/core/theme/input_theme.dart';
import 'package:recomiendalo/core/theme/card_theme.dart';
import 'package:recomiendalo/core/theme/drawer_theme.dart';

/// 🎨 Tema global que unifica todos los subtemas
class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.lightScheme,
      textTheme: GoogleFonts.interTextTheme(),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.surfaceLight,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorSchemes.lightScheme.surface,
        foregroundColor: AppColorSchemes.lightScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.grayLight,
        thickness: 1,
      ),
      listTileTheme: const ListTileThemeData(iconColor: AppColors.grayDark),
      inputDecorationTheme: AppInputTheme.light,
      filledButtonTheme: AppButtonTheme.filledLight,
      outlinedButtonTheme: AppButtonTheme.outlinedLight,
      cardTheme: AppCardTheme.light,
      drawerTheme: AppDrawerTheme.light,
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      colorScheme: AppColorSchemes.darkScheme,
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      scaffoldBackgroundColor: AppColors.surfaceDark,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorSchemes.darkScheme.surface,
        foregroundColor: AppColorSchemes.darkScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.grayDark.withValues(alpha: 0.45),
        thickness: 1,
      ),
      listTileTheme: const ListTileThemeData(iconColor: AppColors.grayLight),
      inputDecorationTheme: AppInputTheme.dark,
      filledButtonTheme: AppButtonTheme.filledDark,
      outlinedButtonTheme: AppButtonTheme.outlinedDark,
      cardTheme: AppCardTheme.dark,
      drawerTheme: AppDrawerTheme.dark,
    );
  }
}
