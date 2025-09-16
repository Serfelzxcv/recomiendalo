import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema centralizado de la aplicación.
/// Aquí configuramos colores, tipografía y estilos globales.
class AppTheme {
  /// Tema claro principal de la app
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 17, 146, 103), // Verde turquesa vibrante
      ),
      textTheme: GoogleFonts.interTextTheme(),
    );

  return base.copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: base.colorScheme.primary,
      foregroundColor: base.colorScheme.onPrimary,
      centerTitle: true,
      titleTextStyle: base.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: base.colorScheme.onPrimary,
      ),
    ),
    // 👇 Aquí el cambio: CardThemeData en lugar de CardTheme
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(8),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: base.colorScheme.primary,
      textColor: base.colorScheme.onSurface,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: base.colorScheme.surfaceVariant,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        minimumSize: const Size.fromHeight(48),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(color: base.colorScheme.primary),
        minimumSize: const Size.fromHeight(48),
      ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: base.colorScheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
    ),
  );
  }

  /// Tema oscuro preparado (aún no lo usamos)
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
    );
  }
}
