import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema centralizado de la aplicación.
/// Paleta: Negro (#000000), Blanco (#FFFFFF), Turquesa (#27C3AE)
class AppTheme {
  static const primaryColor = Color(0xFF27C3AE);
  static const black = Colors.black;
  static const white = Colors.white;

  /// Tema claro
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: white,
        secondary: primaryColor,
        onSecondary: white,
        error: Colors.red,
        onError: white,
        background: white,
        onBackground: black,
        surface: white,
        onSurface: black,
      ),
      textTheme: GoogleFonts.interTextTheme(),
    );

    return base.copyWith(
      /// AppBar blanco con texto negro (minimalista)
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
        centerTitle: true,
      ),

      /// Tarjetas limpias con bordes suaves
      cardTheme: CardThemeData(
        elevation: 0,
        color: white,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey[200]!),
        ),
      ),

      /// ListTiles: texto negro, iconos turquesa
      listTileTheme: const ListTileThemeData(
        iconColor: primaryColor,
        textColor: black,
      ),

      /// Inputs estilo minimal
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        hintStyle: TextStyle(color: Colors.grey[500]),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),

      /// Botón principal turquesa (bien visible)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          minimumSize: const Size.fromHeight(48),
        ),
      ),

      /// Botón secundario (outline negro)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: black, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size.fromHeight(48),
          foregroundColor: black,
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),

      /// Drawer blanco con esquinas redondeadas
      drawerTheme: const DrawerThemeData(
        backgroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  /// Tema oscuro
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary: black,
        secondary: primaryColor,
        onSecondary: black,
        background: black,
        onBackground: white,
        surface: Color(0xFF121212),
        onSurface: white,
        error: Colors.red,
        onError: white,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: black,
        foregroundColor: white,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        hintStyle: TextStyle(color: Colors.grey[500]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}
